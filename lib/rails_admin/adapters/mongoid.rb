require 'mongoid'
require 'rails_admin/config/sections/list'
require 'rails_admin/adapters/mongoid/abstract_object'

module RailsAdmin
  module Adapters
    module Mongoid
      STRING_TYPE_COLUMN_NAMES = [:name, :title, :subject]
      DISABLED_COLUMN_TYPES = ['Range', 'Moped::BSON::Binary', "BSON::Binary"]
      ObjectId = defined?(Moped::BSON) ? Moped::BSON::ObjectId : BSON::ObjectId


      def new(params = {})
        AbstractObject.new(model.new)
      end

      def get(id)
        begin
          AbstractObject.new(model.find(id))
        rescue => e
          raise e if %w[
            BSON::InvalidObjectId
            Mongoid::Errors::DocumentNotFound
            Mongoid::Errors::InvalidFind
            Moped::Errors::InvalidObjectId
          ].exclude?(e.class.to_s)
        end
      end

      def scoped
        model.scoped
      end

      def first(options = {},scope=nil)
        all(options, scope).first
      end

      def all(options = {},scope=nil)
        scope ||= self.scoped
        scope = scope.includes(*options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.any_in(:_id => options[:bulk_ids]) if options[:bulk_ids]
        scope = scope.where(query_conditions(options[:query])) if options[:query]
        scope = scope.where(filter_conditions(options[:filters])) if options[:filters]
        if options[:page] && options[:per]
          scope = scope.send(Kaminari.config.page_method_name, options[:page]).per(options[:per])
        end
        scope = sort_by(options, scope) if options[:sort]
        scope
      end

      def count(options = {},scope=nil)
        all(options.merge({:limit => false, :page => false}), scope).count
      end

      def destroy(objects)
        Array.wrap(objects).each &:destroy
      end

      def primary_key
        '_id'
      end

      def associations
        model.associations.values.map do |association|
          Association.new(association, model).to_options_hash
        end
      end

      def properties
        fields = model.fields.reject{|name, field| DISABLED_COLUMN_TYPES.include?(field.type.to_s) }
        fields.map do |name,field|
          {
            :name => field.name.to_sym,
            :length => nil,
            :pretty_name => field.name.to_s.gsub('_', ' ').strip.capitalize,
            :nullable? => true,
            :serial? => false,
          }.merge(type_lookup(name, field))
        end
      end

      def table_name
        model.collection_name.to_s
      end

      def encoding
        'UTF-8'
      end

      def embedded?
        @embedded ||= !!model.associations.values.find{|a| a.macro.to_sym == :embedded_in }
      end

      def cyclic?
        @cyclic ||= !!model.cyclic?
      end

      def adapter_supports_joins?
        false
      end

      private

      def build_statement(column, type, value, operator)
        StatementBuilder.new(column, type, value, operator).to_statement
      end

      def make_field_conditions(field, value, operator)
        conditions_per_collection = {}
        field.searchable_columns.each do |column_infos|
          collection_name, column_name = parse_collection_name(column_infos[:column])
          statement = build_statement(column_name, column_infos[:type], value, operator)
          if statement
            conditions_per_collection[collection_name] ||= []
            conditions_per_collection[collection_name] << statement
          end
        end
        conditions_per_collection
      end

      def query_conditions(query, fields = config.list.fields.select(&:queryable?))
        statements = []

        fields.each do |field|
          conditions_per_collection = make_field_conditions(field, query, field.search_operator)
          statements.concat make_condition_for_current_collection(field, conditions_per_collection)
        end

        if statements.any?
          { '$or' => statements }
        else
          {}
        end
      end

      # filters example => {"string_field"=>{"0055"=>{"o"=>"like", "v"=>"test_value"}}, ...}
      # "0055" is the filter index, no use here. o is the operator, v the value
      def filter_conditions(filters, fields = config.list.fields.select(&:filterable?))
        statements = []

        filters.each_pair do |field_name, filters_dump|
          filters_dump.each do |_, filter_dump|
            field = fields.find{|f| f.name.to_s == field_name}
            next unless field
            conditions_per_collection = make_field_conditions(field, filter_dump[:v], (filter_dump[:o] || 'default'))
            field_statements = make_condition_for_current_collection(field, conditions_per_collection)
            if field_statements.many?
              statements << { '$or' => field_statements }
            elsif field_statements.any?
              statements << field_statements.first
            end
          end
        end

        if statements.any?
          { '$and' => statements }
        else
          {}
        end
      end

      def type_lookup(name, field)
        {
          "Array"          => { :type => :serialized },
          "BigDecimal"     => { :type => :decimal },
          "Mongoid::Boolean"        => { :type => :boolean },
          "Boolean"        => { :type => :boolean },
          "BSON::ObjectId" => { :type => :bson_object_id, :serial? => (name == primary_key) },
          "Moped::BSON::ObjectId" => { :type => :bson_object_id, :serial? => (name == primary_key) },
          "Date"           => { :type => :date },
          "DateTime"       => { :type => :datetime },
          "ActiveSupport::TimeWithZone" => { :type => :datetime },
          "Float"          => { :type => :float },
          "Hash"           => { :type => :serialized },
          "Money"          => { :type => :serialized },
          "Integer"        => { :type => :integer },
          "Object"         => (
            if associations.find{|a| a[:type] == :belongs_to && a[:foreign_key] == name.to_sym}
              { :type => :bson_object_id }
            else
              { :type => :string, :length => 255 }
            end
          ),
            "String"         => (
              if (length = length_validation_lookup(name)) && length < 256
                { :type => :string, :length => length }
              elsif STRING_TYPE_COLUMN_NAMES.include?(name.to_sym)
                { :type => :string, :length => 255 }
              else
                { :type => :text }
              end
          ),
            "Symbol"         => { :type => :string, :length => 255 },
            "Time"           => { :type => :datetime },
        }[field.type.to_s] or raise "Type #{field.type.to_s} for field :#{name} in #{model.inspect} not supported"
      end

      def length_validation_lookup(name)
        shortest = model.validators.select do |validator|
          validator.respond_to?(:attributes) &&
            validator.attributes.include?(name.to_sym) &&
            validator.kind == :length &&
            validator.options[:maximum]
        end.min{|a, b| a.options[:maximum] <=> b.options[:maximum] }

        shortest && shortest.options[:maximum]
      end

      def parse_collection_name(column)
        collection_name, column_name = column.split('.')
        if [:embeds_one, :embeds_many].include?(model.associations[collection_name].try(:macro).try(:to_sym))
          [table_name, column]
        else
          [collection_name, column_name]
        end
      end

      def make_condition_for_current_collection(target_field, conditions_per_collection)
        result =[]
        conditions_per_collection.each do |collection_name, conditions|
          if collection_name == table_name
            # conditions referring current model column are passed directly
            result.concat conditions
          else
            # otherwise, collect ids of documents that satisfy search condition
            result.concat perform_search_on_associated_collection(target_field.name, conditions)
          end
        end
        result
      end

      def perform_search_on_associated_collection(field_name, conditions)
        target_association = associations.find{|a| a[:name] == field_name }
        return [] unless target_association
        model = target_association[:model_proc].call
        case target_association[:type]
        when :belongs_to, :has_and_belongs_to_many
          [{ target_association[:foreign_key].to_s => { '$in' => model.where('$or' => conditions).all.map{|r| r.send(target_association[:primary_key_proc].call)} }}]
        when :has_many
          [{ target_association[:primary_key_proc].call.to_s => { '$in' => model.where('$or' => conditions).all.map{|r| r.send(target_association[:foreign_key])} }}]
        end
      end

      def sort_by(options, scope)
        return scope unless options[:sort]

        case options[:sort]
        when String
          field_name, collection_name = options[:sort].split('.').reverse
          if collection_name && collection_name != table_name
            raise "sorting by associated model column is not supported in Non-Relational databases"
          end
        when Symbol
          field_name = options[:sort].to_s
        end
        if options[:sort_reverse]
          scope.asc field_name
        else
          scope.desc field_name
        end
      end

      private
      class Association
        attr_reader :association, :model
        def initialize(association, model)
          @association = association
          @model = model
          @options = association.options
        end

        def to_options_hash
          {
            :name => name.to_sym,
            :pretty_name => display_name,
            :type => type_lookup,
            :model_proc => Proc.new { model_proc_lookup },
            :primary_key_proc => Proc.new { primary_key_lookup },
            :foreign_key => foreign_key_lookup,
            :foreign_type => foreign_type_lookup,
            :foreign_inverse_of => foreign_inverse_of_lookup,
            :as => as_lookup,
            :polymorphic => polymorphic_lookup,
            :inverse_of => inverse_of_lookup,
            :read_only => nil,
            :nested_form => nested_attributes_options_lookup
          }
        end

        private

        def display_name
          name.to_s.tr('_', ' ').capitalize
        end

        def model_proc_lookup
          if polymorphic? && [:referenced_in, :belongs_to].include?(macro)
            polymorphic_parents(:mongoid, model_name, name) || []
          else
            klass
          end
        end

        def foreign_type_lookup
          if polymorphic? && [:referenced_in, :belongs_to].include?(macro)
            inverse_type.try(:to_sym) || :"#{name}_type"
          end
        end

        def foreign_inverse_of_lookup
          if polymorphic? && [:referenced_in, :belongs_to].include?(macro)
            inverse_of_field.try(:to_sym)
          end
        end

        def nested_attributes_options_lookup
          nested = model_nested_attributes_options.try { |o| o[name.to_sym] }
          if !nested && [:embeds_one, :embeds_many].include?(macro.to_sym) && !association.cyclic
            raise <<-MSG.gsub(/^\s+/, '')
            Embbeded association without accepts_nested_attributes_for can't be handled by RailsAdmin,
            because embedded model doesn't have top-level access.
            Please add `accepts_nested_attributes_for :#{association.name}' line to `#{model.to_s}' model.
            MSG
          end
          nested
        end

        def as_lookup
          as.try :to_sym
        end

        def polymorphic_lookup
          !!polymorphic? && [:referenced_in, :belongs_to].include?(macro)
        end

        def primary_key_lookup
          :_id # todo
        end

        def inverse_of_field
          association.respond_to?(:inverse_of_field) && association.inverse_of_field
        end

        def inverse_of_lookup
          inverse_of.try :to_sym
        end

        def foreign_key_lookup
          if [:embeds_one, :embeds_many].exclude?(macro.to_sym)
            foreign_key.to_sym rescue nil
          end
        end

        def type_lookup
          case macro.to_sym
          when :belongs_to, :referenced_in, :embedded_in
            :belongs_to
          when :has_one, :references_one, :embeds_one
            :has_one
          when :has_many, :references_many, :embeds_many
            :has_many
          when :has_and_belongs_to_many, :references_and_referenced_in_many
            :has_and_belongs_to_many
          else
            raise "Unknown association type: #{macro.inspect}"
          end
        end

        delegate :foreign_key, :macro, :name, :options, :scope, :polymorphic?,
                 :klass, :inverse_of, :inverse_type, :as,
                 :to => :association, :prefix => false
        delegate :name, :nested_attributes_options, :to => :model, :prefix => true
        delegate :polymorphic_parents, :to => RailsAdmin::AbstractModel
      end

      class StatementBuilder < RailsAdmin::AbstractModel::StatementBuilder
        protected

        def unary_operators
          {
            '_blank' => { @column => {'$in' => [nil, '']} },
            '_present' => { @column => {'$nin' => [nil, '']} },
            '_null' => { @column => nil },
            '_not_null' => { @column => {'$ne' => nil} },
            '_empty' => { @column => '' },
            '_not_empty' => { @column => {'$ne' => ''} }
          }
        end

        private

        def build_statement_for_type
          case @type
            when :boolean                   then build_statement_for_boolean
            when :integer, :decimal, :float then build_statement_for_integer_decimal_or_float
            when :string, :text             then build_statement_for_string_or_text
            when :enum                      then build_statement_for_enum
            when :belongs_to_association, :bson_object_id then build_statement_for_belongs_to_association_or_bson_object_id
          end
        end

        def build_statement_for_boolean
          return { @column => false } if %w[false f 0].include?(@value)
          return { @column => true } if %w[true t 1].include?(@value)
        end

        def column_for_value(value)
          { @column => value }
        end

        def build_statement_for_string_or_text
          return if @value.blank?
          @value = case @operator
          when 'default', 'like'
            Regexp.compile(Regexp.escape(@value), Regexp::IGNORECASE)
          when 'starts_with'
            Regexp.compile("^#{Regexp.escape(@value)}", Regexp::IGNORECASE)
          when 'ends_with'
            Regexp.compile("#{Regexp.escape(@value)}$", Regexp::IGNORECASE)
          when 'is', '='
            @value.to_s
          else
            return
          end
          { @column => @value }
        end

        def build_statement_for_enum
          return if @value.blank?
          { @column => { "$in" => Array.wrap(@value) } }
        end

        def build_statement_for_belongs_to_association_or_bson_object_id
          object_id = (object_id_from_string(@value) rescue nil)
          { @column => object_id } if object_id
        end

        def range_filter(min, max)
          if min && max
            { @column => { '$gte' => min, '$lte' => max } }
          elsif min
            { @column => { '$gte' => min } }
          elsif max
            { @column => { '$lte' => max } }
          end
        end

        def object_id_from_string(str)
          ObjectId.from_string(str)
        end

      end
    end
  end
end
