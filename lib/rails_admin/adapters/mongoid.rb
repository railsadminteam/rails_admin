require 'mongoid'
require 'rails_admin/config/sections/list'
require 'rails_admin/adapters/mongoid/abstract_object'

module RailsAdmin
  module Adapters
    module Mongoid
      STRING_TYPE_COLUMN_NAMES = [:name, :title, :subject]

      def new(params = {})
        AbstractObject.new(model.new)
      end

      def get(id)
        if object = model.where(:_id=>BSON::ObjectId(id)).first
          AbstractObject.new object
        else
          nil
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
        scope = scope.includes(options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.any_in(:_id => options[:bulk_ids]) if options[:bulk_ids]
        scope = scope.where(query_conditions(options[:query])) if options[:query]
        scope = scope.where(filter_conditions(options[:filters])) if options[:filters]
        scope = scope.page(options[:page]).per(options[:per]) if options[:page] && options[:per]
        scope = if options[:sort] && options[:sort_reverse]
          scope.desc(options[:sort])
        elsif options[:sort]
          scope.asc(options[:sort])
        else
          scope
        end
      end
      
      def count(options = {},scope=nil)
        all(options.merge({:limit => false, :page => false}), scope).count
      end

      def destroy(objects)
        Array.wrap(objects).each &:destroy
      end

      def primary_key
        :_id
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
            :as => association_as_lookup(association),
            :polymorphic => association_polymorphic_lookup(association),
            :inverse_of => association_inverse_of_lookup(association),
            :read_only => nil,
            :nested_form => nil
          }
        end
      end

      def properties
        @properties if @properties
        @properties = model.fields.map do |name,field|
          ar_type =
            if name == '_type'
              { :type => :mongoid_type, :length => 1024 }
            elsif field.type.to_s == 'String'
              if (length = length_validation_lookup(name)) && length < 256
                { :type => :string, :length => length }
              elsif STRING_TYPE_COLUMN_NAMES.include?(name.to_sym)
                { :type => :string, :length => 255 }
              else
                { :type => :text, :length => nil }
              end
            else
              {
                "Array"          => { :type => :serialized, :length => nil },
                "BigDecimal"     => { :type => :string, :length => 1024 },
                "Boolean"        => { :type => :boolean, :length => nil },
                "BSON::ObjectId" => { :type => :bson_object_id, :length => nil },
                "Date"           => { :type => :date, :length => nil },
                "DateTime"       => { :type => :datetime, :length => nil },
                "Float"          => { :type => :float, :length => nil },
                "Hash"           => { :type => :serialized, :length => nil },
                "Integer"        => { :type => :integer, :length => nil },
                "Time"           => { :type => :datetime, :length => nil },
                "Object"         => { :type => :bson_object_id, :length => nil },
              }[field.type.to_s] or raise "Need to map field #{field.type.to_s} for field name #{name} in #{model.inspect}"
            end

          {
            :name => field.name.to_sym,
            :pretty_name => field.name.to_s.gsub('_', ' ').strip.capitalize,
            :nullable? => true,
            :serial? => false,
          }.merge(ar_type)
        end
      end

      def table_name
        model.collection.name
      end

      def serialized_attributes
        # Mongoid Array and Hash type columns are mapped to RA serialized type
        # through type detection in self#properties.
        []
      end

      private

      def query_conditions(query, fields = config.list.fields.select(&:queryable?))
        statements = []

        fields.each do |field|
          conditions_per_collection = {}
          field.searchable_columns.flatten.each do |column_infos|
            collection_name, column_name = column_infos[:column].split('.')
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
              collection_name, column_name = column_infos[:column].split('.')
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
        when :integer, :belongs_to_association
          return if value.blank?
          { column => value.to_i } if value.to_i.to_s == value
        when :string, :text
          return if value.blank?
          value = case operator
          when 'default', 'like'
            Regexp.compile(Regexp.escape(value))
          when 'starts_with'
            Regexp.compile("^#{Regexp.escape(value)}")
          when 'ends_with'
            Regexp.compile("#{Regexp.escape(value)}$")
          when 'is', '='
            value.to_s
          else
            return
          end
          { column => value }
        when :datetime, :timestamp, :date
          start_date, end_date = get_filtering_duration(operator, value)

          if start_date && end_date
            { column => { '$gte' => start_date, '$lte' => end_date } }
          elsif start_date
            { column => { '$gte' => start_date } }
          elsif end_date
            { column => { '$lte' => end_date } }
          end
        when :enum
          return if value.blank?
          { column => { "$in" => Array.wrap(value) } }
        end
      end

      def association_model_proc_lookup(association)
        if association.polymorphic? && association.macro == :referenced_in
          RailsAdmin::AbstractModel.polymorphic_parents(:mongoid, association.name) || []
        else
          association.klass
        end
      end

      def association_foreign_type_lookup(association)
        if association.polymorphic? && association.macro == :referenced_in
          association.inverse_type.try(:to_sym) || :"#{association.name}_type"
        end
      end

      def association_as_lookup(association)
        association.as.try :to_sym
      end

      def association_polymorphic_lookup(association)
        !!association.polymorphic? && association.macro == :referenced_in
      end

      def association_primary_key_lookup(association)
        :_id # todo
      end

      def association_inverse_of_lookup(association)
        association.inverse_of.try :to_sym
      end

      def association_foreign_key_lookup(association)
        association.foreign_key.to_sym rescue nil
      end
      
      def association_type_lookup(macro)
        case macro.to_sym
        when :referenced_in, :embedded_in
          :belongs_to
        when :references_one, :embeds_one
          :has_one
        when :references_many, :embeds_many
          :has_many
        when :references_and_referenced_in_many
          :has_and_belongs_to_many
        else
          raise "Unknown association type: #{macro.inspect}"
        end
      end

      def length_validation_lookup(name)
        shortest = model.validators.select do |validator|
          validator.attributes.include?(name.to_sym) &&
            validator.class == ActiveModel::Validations::LengthValidator
        end.min{|a, b| a.options[:maximum] <=> b.options[:maximum] }
        if shortest
          shortest.options[:maximum]
        else
          false
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
    end
  end
end
