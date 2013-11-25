require 'active_record'
require 'rails_admin/adapters/active_record/abstract_object'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = [:tsvector, :blob, :binary, :spatial, :hstore, :geometry]
      DISABLED_COLUMN_MATCHERS = [/_array$/]

      def new(params = {})
        AbstractObject.new(model.new(params))
      end

      def get(id)
        if object = model.where(primary_key => id).first
          AbstractObject.new object
        end
      end

      def scoped
        model.all
      end

      def first(options = {}, scope = nil)
        all(options, scope).first
      end

      def all(options = {}, scope = nil)
        scope ||= self.scoped
        scope = scope.includes(options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.where(primary_key => options[:bulk_ids]) if options[:bulk_ids]
        scope = query_scope(scope, options[:query]) if options[:query]
        scope = filter_scope(scope, options[:filters]) if options[:filters]
        if options[:page] && options[:per]
          scope = scope.send(Kaminari.config.page_method_name, options[:page]).per(options[:per])
        end
        scope = scope.reorder("#{options[:sort]} #{options[:sort_reverse] ? 'asc' : 'desc'}") if options[:sort]
        scope
      end

      def count(options = {}, scope = nil)
        all(options.merge({:limit => false, :page => false}), scope).count
      end

      def destroy(objects)
        Array.wrap(objects).each &:destroy
      end

      def associations
        model.reflect_on_all_associations.map do |association|
          Association.new(association, model).to_options_hash
        end
      end

      def properties
        columns = model.columns.reject do |c|
          c.type.blank? ||
            DISABLED_COLUMN_TYPES.include?(c.type.to_sym) ||
            DISABLED_COLUMN_MATCHERS.any? {|matcher| matcher.match(c.type.to_s)}
        end
        columns.map do |property|
          {
            :name => property.name.to_sym,
            :pretty_name => property.name.to_s.tr('_', ' ').capitalize,
            :length => property.limit,
            :nullable? => property.null,
            :serial? => property.primary,
          }.merge(type_lookup(property))
        end
      end

      delegate :primary_key, :table_name, :to => :model, :prefix => false

      def encoding
        Rails.configuration.database_configuration[Rails.env]['encoding']
      end

      def embedded?
        false
      end

      def cyclic?
        false
      end

      def adapter_supports_joins?
        true
      end

      private

      class WhereBuilder

        def initialize(scope)
          @statements = []
          @values = []
          @tables = []
          @scope = scope
        end

        def add(field, value, operator)
          field.searchable_columns.flatten.each do |column_infos|
            statement, value1, value2 = StatementBuilder.new(column_infos[:column], column_infos[:type], value, operator).to_statement
            @statements << statement if statement.present?
            @values << value1 unless value1.nil?
            @values << value2 unless value2.nil?
            table, column = column_infos[:column].split('.')
            @tables.push(table) if column
          end
        end

        def build
          @scope.where(@statements.join(' OR '), *@values).references(*(@tables.uniq))
        end
      end

      def query_scope(scope, query, fields = config.list.fields.select(&:queryable?))
        wb = WhereBuilder.new(scope)
        fields.each do |field|
          wb.add(field, query, field.search_operator)
        end
        # OR all query statements
        wb.build
      end

      # filters example => {"string_field"=>{"0055"=>{"o"=>"like", "v"=>"test_value"}}, ...}
      # "0055" is the filter index, no use here. o is the operator, v the value
      def filter_scope(scope, filters, fields = config.list.fields.select(&:filterable?))
        filters.each_pair do |field_name, filters_dump|
          filters_dump.each do |_, filter_dump|
            wb = WhereBuilder.new(scope)
            wb.add(fields.find{|f| f.name.to_s == field_name}, filter_dump[:v], (filter_dump[:o] || 'default'))
            # AND current filter statements to other filter statements
            scope = wb.build
          end
        end
        scope
      end

      def build_statement(column, type, value, operator)
        StatementBuilder.new(column, type, value, operator).to_statement
      end

      def type_lookup(property)
        if model.serialized_attributes[property.name.to_s]
          {:type => :serialized}
        else
          {:type => property.type}
        end
      end

      class Association
        attr_reader :association, :model

        def initialize(association, model)
          @association = association
          @model = model
        end

        def to_options_hash
          {
            :name => name.to_sym,
            :pretty_name => display_name,
            :type => macro,
            :model_proc => Proc.new { model_lookup },
            :primary_key_proc => Proc.new { primary_key_lookup },
            :foreign_key => foreign_key.to_sym,
            :foreign_type => foreign_type_lookup,
            :as => as_lookup,
            :polymorphic => polymorphic_lookup,
            :inverse_of => inverse_of_lookup,
            :read_only => read_only_lookup,
            :nested_form => nested_attributes_options_lookup
          }
        end

        private
        def model_lookup
          if options[:polymorphic]
            polymorphic_parents(:active_record, model_name.to_s, name) || []
          else
            klass
          end
        end

        def foreign_type_lookup
          options[:foreign_type].try(:to_sym) || :"#{name}_type" if options[:polymorphic]
        end

        def nested_attributes_options_lookup
          model.nested_attributes_options.try { |o| o[name.to_sym] }
        end

        def as_lookup
          options[:as].try :to_sym
        end

        def polymorphic_lookup
          !!options[:polymorphic]
        end

        def primary_key_lookup
          options[:primary_key] || klass.primary_key
        end

        def inverse_of_lookup
          options[:inverse_of].try :to_sym
        end

        def read_only_lookup
          klass.all.instance_eval(&scope).readonly_value if scope.is_a? Proc
        end

        def display_name
          name.to_s.tr('_', ' ').capitalize
        end

        delegate :klass, :macro, :name, :options, :scope, :foreign_key,
                 :to => :association, :prefix => false
        delegate :name, :to => :model, :prefix => true
        delegate :polymorphic_parents, :to => RailsAdmin::AbstractModel
      end

      class StatementBuilder < RailsAdmin::AbstractModel::StatementBuilder
        protected

        def unary_operators
          {
            '_blank' => ["(#{@column} IS NULL OR #{@column} = '')"],
            '_present' => ["(#{@column} IS NOT NULL AND #{@column} != '')"],
            '_null' => ["(#{@column} IS NULL)"],
            '_not_null' => ["(#{@column} IS NOT NULL)"],
            '_empty' => ["(#{@column} = '')"],
            '_not_empty' => ["(#{@column} != '')"]
          }
        end

        private

        def range_filter(min, max)
          if min && max
            ["(#{@column} BETWEEN ? AND ?)", min, max]
          elsif min
            ["(#{@column} >= ?)", min]
          elsif max
            ["(#{@column} <= ?)", max]
          end
        end

        def build_statement_for_type
          case @type
            when :boolean                   then build_statement_for_boolean
            when :integer, :decimal, :float then build_statement_for_integer_decimal_or_float
            when :string, :text             then build_statement_for_string_or_text
            when :enum                      then build_statement_for_enum
            when :belongs_to_association    then build_statement_for_belongs_to_association
          end
        end

        def build_statement_for_boolean
          return ["(#{@column} IS NULL OR #{@column} = ?)", false] if %w[false f 0].include?(@value)
          return ["(#{@column} = ?)", true] if %w[true t 1].include?(@value)
        end

        def column_for_value(value)
          ["(#{@column} = ?)", value]
        end

        def build_statement_for_belongs_to_association
          return if @value.blank?
          ["(#{@column} = ?)", @value.to_i] if @value.to_i.to_s == @value
        end

        def build_statement_for_string_or_text
          return if @value.blank?
          @value = case @operator
          when 'default', 'like'
            "%#{@value.downcase}%"
          when 'starts_with'
            "#{@value.downcase}%"
          when 'ends_with'
            "%#{@value.downcase}"
          when 'is', '='
            "#{@value.downcase}"
          else
            return
          end
          ["(LOWER(#{@column}) #{like_operator} ?)", @value]
        end

        def build_statement_for_enum
          return if @value.blank?
          ["(#{@column} IN (?))", Array.wrap(@value)]
        end

        def ar_adapter
          Rails.configuration.database_configuration[Rails.env]['adapter']
        end

        def like_operator
          ar_adapter == "postgresql" ? 'ILIKE' : 'LIKE'
        end
      end
    end
  end
end
