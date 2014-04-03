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
        scope ||= scoped
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
        all(options.merge(limit: false, page: false), scope).count
      end

      def destroy(objects)
        Array.wrap(objects).each(&:destroy)
      end

      def associations
        model.reflect_on_all_associations.collect do |association|
          Association.new(association, model)
        end
      end

      def properties
        columns = model.columns.reject do |c|
          c.type.blank? ||
            DISABLED_COLUMN_TYPES.include?(c.type.to_sym) ||
            DISABLED_COLUMN_MATCHERS.any? { |matcher| matcher.match(c.type.to_s) }
        end
        columns.collect do |property|
          Property.new(property, model)
        end
      end

      delegate :primary_key, :table_name, to: :model, prefix: false

      def encoding
        encoding = ::ActiveRecord::Base.connection.try(:encoding)
        encoding ||= ::ActiveRecord::Base.connection.try(:charset) # mysql2
        encoding || 'UTF-8'
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
          scope = @scope.where(@statements.join(' OR '), *@values)
          scope = scope.references(*(@tables.uniq)) if @tables.any?
          scope
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
            wb.add(fields.detect { |f| f.name.to_s == field_name }, filter_dump[:v], (filter_dump[:o] || 'default'))
            # AND current filter statements to other filter statements
            scope = wb.build
          end
        end
        scope
      end

      def build_statement(column, type, value, operator)
        StatementBuilder.new(column, type, value, operator).to_statement
      end

      class Property
        attr_reader :property, :model

        def initialize(property, model)
          @property = property
          @model = model
        end

        def name
          property.name.to_sym
        end

        def pretty_name
          property.name.to_s.tr('_', ' ').capitalize
        end

        def type
          if model.serialized_attributes[property.name.to_s]
            :serialized
          else
            property.type
          end
        end

        def length
          property.limit
        end

        def nullable?
          property.null
        end

        def serial?
          property.primary
        end

        def association?
          false
        end

        def read_only?
          false
        end
      end

      class Association
        attr_reader :association, :model

        def initialize(association, model)
          @association = association
          @model = model
        end

        def name
          association.name.to_sym
        end

        def pretty_name
          name.to_s.tr('_', ' ').capitalize
        end

        def type
          association.macro
        end

        def klass
          if options[:polymorphic]
            polymorphic_parents(:active_record, model.name.to_s, name) || []
          else
            association.klass
          end
        end

        def primary_key
          (options[:primary_key] || association.klass.primary_key).try(:to_sym) unless polymorphic?
        end

        def foreign_key
          association.foreign_key.to_sym
        end

        def foreign_type
          options[:foreign_type].try(:to_sym) || :"#{name}_type" if options[:polymorphic]
        end

        def foreign_inverse_of
          nil
        end

        def as
          options[:as].try :to_sym
        end

        def polymorphic?
          options[:polymorphic] || false
        end

        def inverse_of
          options[:inverse_of].try :to_sym
        end

        def read_only?
          (klass.all.instance_eval(&scope).readonly_value if scope.is_a? Proc) || false
        end

        def nested_options
          model.nested_attributes_options.try { |o| o[name.to_sym] }
        end

        def association?
          true
        end

        delegate :options, :scope, to: :association, prefix: false
        delegate :polymorphic_parents, to: RailsAdmin::AbstractModel
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
          ::ActiveRecord::Base.connection.adapter_name.downcase
        end

        def like_operator
          ar_adapter == 'postgresql' ? 'ILIKE' : 'LIKE'
        end
      end
    end
  end
end
