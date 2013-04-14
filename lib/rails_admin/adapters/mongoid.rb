require 'mongoid'
require 'rails_admin/config/sections/list'
require 'rails_admin/adapters/mongoid/abstract_object'

module RailsAdmin
  module Adapters
    module Mongoid
      STRING_TYPE_COLUMN_NAMES = [:name, :title, :subject]
      DISABLED_COLUMN_TYPES = ['Range', 'Moped::BSON::Binary']
      ObjectId = (::Mongoid::VERSION >= '3' ? ::Moped::BSON::ObjectId : ::BSON::ObjectId)

      def new(params = {})
        AbstractObject.new(model.new)
      end

      def get(id)
        begin
          AbstractObject.new(model.find(id))
        rescue => e
          if ['BSON::InvalidObjectId', 'Mongoid::Errors::DocumentNotFound',
              'Mongoid::Errors::InvalidFind', 'Moped::Errors::InvalidObjectId'].include? e.class.to_s
            nil
          else
            raise e
          end
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
          {
            :name => association.name.to_sym,
            :pretty_name => association.name.to_s.tr('_', ' ').capitalize,
            :type => association_type_lookup(association.macro),
            :model_proc => Proc.new { association_model_proc_lookup(association) },
            :primary_key_proc => Proc.new { association_primary_key_lookup(association) },
            :foreign_key => association_foreign_key_lookup(association),
            :foreign_type => association_foreign_type_lookup(association),
            :foreign_inverse_of => association_foreign_inverse_of_lookup(association),
            :as => association_as_lookup(association),
            :polymorphic => association_polymorphic_lookup(association),
            :inverse_of => association_inverse_of_lookup(association),
            :read_only => nil,
            :nested_form => association_nested_attributes_options_lookup(association)
          }
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

      def object_id_from_string(str)
        ObjectId.from_string(str)
      end

      def adapter_supports_joins?
        false
      end

      private

      def query_conditions(query, fields = config.list.fields.select(&:queryable?))
        statements = []

        fields.each do |field|
          conditions_per_collection = {}
          field.searchable_columns.flatten.each do |column_infos|
            collection_name, column_name = parse_collection_name(column_infos[:column])
            statement = build_statement(column_name, column_infos[:type], query, field.search_operator)
            if statement
              conditions_per_collection[collection_name] ||= []
              conditions_per_collection[collection_name] << statement
            end
          end
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
          filters_dump.each do |filter_index, filter_dump|
            conditions_per_collection = {}
            field = fields.find{|f| f.name.to_s == field_name}
            next unless field
            field.searchable_columns.each do |column_infos|
              collection_name, column_name = parse_collection_name(column_infos[:column])
              statement = build_statement(column_name, column_infos[:type], filter_dump[:v], (filter_dump[:o] || 'default'))
              if statement
                conditions_per_collection[collection_name] ||= []
                conditions_per_collection[collection_name] << statement
              end
            end
            if conditions_per_collection.any?
              field_statements = make_condition_for_current_collection(field, conditions_per_collection)
              if field_statements.length > 1
                statements << { '$or' => field_statements }
              else
                statements << field_statements.first
              end
            end
          end
        end

        if statements.any?
          { '$and' => statements }
        else
          {}
        end
      end

      def build_statement(column, type, value, operator)
        # this operator/value has been discarded (but kept in the dom to override the one stored in the various links of the page)
        return if operator == '_discard' || value == '_discard'

        # filtering data with unary operator, not type dependent
        if operator == '_blank' || value == '_blank'
          return { column => {'$in' => [nil, '']} }
        elsif operator == '_present' || value == '_present'
          return { column => {'$nin' => [nil, '']} }
        elsif operator == '_null' || value == '_null'
          return { column => nil }
        elsif operator == '_not_null' || value == '_not_null'
          return { column => {'$ne' => nil} }
        elsif operator == '_empty' || value == '_empty'
          return { column => '' }
        elsif operator == '_not_empty' || value == '_not_empty'
          return { column => {'$ne' => ''} }
        end
        # now we go type specific
        case type
        when :boolean
          return { column => false } if ['false', 'f', '0'].include?(value)
          return { column => true } if ['true', 't', '1'].include?(value)
        when :integer, :decimal, :float
          case value
          when Array then
            val, range_begin, range_end = *value.map do |v|
              if (v.to_i.to_s == v || v.to_f.to_s == v)
                type == :integer ? v.to_i : v.to_f
              else
                nil
              end
            end
            case operator
            when 'between'
              if range_begin && range_end
                { column => {'$gte' => range_begin, '$lte' => range_end} }
              elsif range_begin
                { column => {'$gte' => range_begin} }
              elsif range_end
                { column => {'$lte' => range_end} }
              end
            else
              { column => val } if val
            end
          else
            if (value.to_i.to_s == value || value.to_f.to_s == value)
              type == :integer ? { column => value.to_i } : { column => value.to_f }
            else
              nil
            end
          end
        when :string, :text
          return if value.blank?
          value = case operator
          when 'default', 'like'
            Regexp.compile(Regexp.escape(value), Regexp::IGNORECASE)
          when 'starts_with'
            Regexp.compile("^#{Regexp.escape(value)}", Regexp::IGNORECASE)
          when 'ends_with'
            Regexp.compile("#{Regexp.escape(value)}$", Regexp::IGNORECASE)
          when 'is', '='
            value.to_s
          else
            return
          end
          { column => value }
        when :date
          start_date, end_date = get_filtering_duration(operator, value)

          if start_date && end_date
            { column => { '$gte' => start_date, '$lte' => end_date } }
          elsif start_date
            { column => { '$gte' => start_date } }
          elsif end_date
            { column => { '$lte' => end_date } }
          end
        when :datetime, :timestamp
          start_date, end_date = get_filtering_duration(operator, value)

          if start_date && end_date
            { column => { '$gte' => start_date.to_time.beginning_of_day, '$lte' => end_date.to_time.end_of_day } }
          elsif start_date
            { column => { '$gte' => start_date.to_time.beginning_of_day } }
          elsif end_date
            { column => { '$lte' => end_date.to_time.end_of_day } }
          end
        when :enum
          return if value.blank?
          { column => { "$in" => Array.wrap(value) } }
        when :belongs_to_association, :bson_object_id
          object_id = (object_id_from_string(value) rescue nil)
          { column => object_id } if object_id
        end
      end

      def type_lookup(name, field)
        {
          "Array"          => { :type => :serialized },
          "BigDecimal"     => { :type => :decimal },
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

      def association_model_proc_lookup(association)
        if association.polymorphic? && [:referenced_in, :belongs_to].include?(association.macro)
          RailsAdmin::AbstractModel.polymorphic_parents(:mongoid, self.model.model_name, association.name) || []
        else
          association.klass
        end
      end

      def association_foreign_type_lookup(association)
        if association.polymorphic? && [:referenced_in, :belongs_to].include?(association.macro)
          association.inverse_type.try(:to_sym) || :"#{association.name}_type"
        end
      end

      def association_foreign_inverse_of_lookup(association)
        if association.polymorphic? && [:referenced_in, :belongs_to].include?(association.macro) && association.respond_to?(:inverse_of_field)
          association.inverse_of_field.try(:to_sym)
        end
      end

      def association_nested_attributes_options_lookup(association)
        nested = model.nested_attributes_options.try { |o| o[association.name.to_sym] }
        if !nested && [:embeds_one, :embeds_many].include?(association.macro.to_sym) && !association.cyclic
          raise <<-MSG.gsub(/^\s+/, '')
          Embbeded association without accepts_nested_attributes_for can't be handled by RailsAdmin,
          because embedded model doesn't have top-level access.
          Please add `accepts_nested_attributes_for :#{association.name}' line to `#{model.to_s}' model.
          MSG
        end
        nested
      end

      def association_as_lookup(association)
        association.as.try :to_sym
      end

      def association_polymorphic_lookup(association)
        !!association.polymorphic? && [:referenced_in, :belongs_to].include?(association.macro)
      end

      def association_primary_key_lookup(association)
        :_id # todo
      end

      def association_inverse_of_lookup(association)
        association.inverse_of.try :to_sym
      end

      def association_foreign_key_lookup(association)
        unless [:embeds_one, :embeds_many].include?(association.macro.to_sym)
          association.foreign_key.to_sym rescue nil
        end
      end

      def association_type_lookup(macro)
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

      def length_validation_lookup(name)
        shortest = model.validators.select do |validator|
          validator.respond_to?(:attributes) &&
            validator.attributes.include?(name.to_sym) &&
            validator.kind == :length &&
            validator.options[:maximum]
        end.min{|a, b| a.options[:maximum] <=> b.options[:maximum] }
        if shortest
          shortest.options[:maximum]
        else
          false
        end
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
    end
  end
end
