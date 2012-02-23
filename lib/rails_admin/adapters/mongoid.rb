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
        criteria_for_options(options).first
      end

      def all(options = {},scope=nil)
        criteria_for_options(options)
      end
      
      def count(options = {},scope=nil)
        criteria_for_options(options).count
      end

      def destroy(ids)
        ids = ids.map{|i| BSON::ObjectId(i)}
        destroyed = Array(model.where(:_id.in=>ids))
        model.destroy_all(:conditions=>{:_id.in=>ids})
        destroyed
      end

      def associations
        model.associations.values.map do |association|
          {
            :name => association.name.to_sym,
            :pretty_name => association.name.to_s.tr('_', ' ').capitalize,
            :type => association_type_lookup(association.macro),
            :parent_model_proc => Proc.new { association_parent_model_lookup(association) },
            :parent_key => association_parent_key_lookup(association),
            :child_model_proc => Proc.new { association_child_model_lookup(association) },
            :child_key => association_child_key_lookup(association),
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
                "Array"          => { :type => :text, :length => nil },
                "BigDecimal"     => { :type => :string, :length => 1024 },
                "Boolean"        => { :type => :boolean, :length => nil },
                "BSON::ObjectId" => { :type => :bson_object_id, :length => nil },
                "Date"           => { :type => :date, :length => nil },
                "DateTime"       => { :type => :datetime, :length => nil },
                "Float"          => { :type => :float, :length => nil },
                "Hash"           => { :type => :string, :length => nil },
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

      def model_store_exists?
        # Collections are created on demand, so they always 'exist'.
        # If need to know if pre-exist we can do something like
        #     model.db.collection_names.include?(model.collection.name)
        true
      end

      def table_name
        model.name.tableize
      end

      def serialized_attributes
        {}
      end

      def accessible_by(*args)
        scoped
      end

      def get_conditions_hash(model_config, query, filters)
        query_statements = []
        filters_statements = []
        conditions = {}

        if query.present?
          queryable_fields = model_config.list.fields.select(&:queryable?)
          queryable_fields.each do |field|
            searchable_columns = field.searchable_columns.flatten
            searchable_columns.each do |field_infos|
              statement = build_statement(field_infos[:column], field_infos[:type], query, field.search_operator)
              if statement
                query_statements << statement
              end
            end
          end
        end

        unless query_statements.empty?
          conditions['$or'] = query_statements
        end

        if filters.present?
          @filterable_fields = model_config.list.fields.select(&:filterable?).inject({}){ |memo, field| memo[field.name.to_sym] = field.searchable_columns; memo }
          filters.each_pair do |field_name, filters_dump|
            filters_dump.each do |filter_index, filter_dump|
              field_statements = []
              @filterable_fields[field_name.to_sym].each do |field_infos|
                statement = build_statement(field_infos[:column], field_infos[:type], filter_dump[:v], (filter_dump[:o] || 'default'))
                if statement
                  field_statements << statement
                end
              end
              filters_statements.push(field_statements) unless field_statements.empty?
            end
          end
        end

        unless filters_statements.empty?
          conditions = { '$and' => [ conditions, filters_statements ].flatten }
        end

        conditions.any? ? { :conditions => conditions } : {}
      end

      private

      def build_statement(column, type, value, operator)
        # remove table_name
        table_prefix = "#{table_name}."
        if column[0, table_prefix.length] == table_prefix
          column = column[table_prefix.length..-1]
        end

        # this operator/value has been discarded (but kept in the dom to override the one stored in the various links of the page)
        return if operator == '_discard' || value == '_discard'

        # filtering data with unary operator, not type dependent
        if operator == '_blank' || value == '_blank'
          return { column => [nil, ''] }
        elsif operator == '_present' || value == '_present'
          return { column => {'$ne' => nil}, column => {'$ne' => ''} }
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
          end
          { column => value }
        when :datetime, :timestamp, :date
          return unless operator != 'default'
          values = case operator
          when 'today'
            [Date.today.beginning_of_day, Date.today.end_of_day]
          when 'yesterday'
            [Date.yesterday.beginning_of_day, Date.yesterday.end_of_day]
          when 'this_week'
            [Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]
          when 'last_week'
            [1.week.ago.to_date.beginning_of_week.beginning_of_day, 1.week.ago.to_date.end_of_week.end_of_day]
          when 'less_than'
            return if value.blank?
            [value.to_i.days.ago, DateTime.now]
          when 'more_than'
            return if value.blank?
            [2000.years.ago, value.to_i.days.ago]
          when 'mmddyyyy'
            return if (value.blank? || value.match(/([0-9]{8})/).nil?)
            [Date.strptime(value.match(/([0-9]{8})/)[1], '%m%d%Y').beginning_of_day, Date.strptime(value.match(/([0-9]{8})/)[1], '%m%d%Y').end_of_day]
          end
          { column => { '$gte' => values[0], '$lte' => values[1] } }
        when :enum
          return if value.blank?
          { column => [value].flatten }
        else
          { column => value }
        end
      end

      def association_parent_model_lookup(association)
        case association.macro
        when :referenced_in
          if association.polymorphic?
            RailsAdmin::AbstractModel.polymorphic_parents(:mongoid, association.name) || []
          else
            association.klass
          end
        when :references_one, :references_many, :references_and_referenced_in_many
          association.inverse_klass
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end

      def association_foreign_type_lookup(association)
        if association.polymorphic?
          association.inverse_type.try(:to_sym) || :"#{association.name}_type"
        end
      end

      def association_as_lookup(association)
        association.as.try :to_sym
      end

      def association_polymorphic_lookup(association)
        association.polymorphic?
      end

      def association_parent_key_lookup(association)
        [:_id]
      end

      def association_inverse_of_lookup(association)
        association.inverse_of.try :to_sym
      end

      def association_child_model_lookup(association)
        case association.macro
        when :referenced_in, :embedded_in
          association.inverse_klass
        when :references_one, :references_many, :references_and_referenced_in_many, :embeds_one, :embeds_many
          association.klass
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end

      def association_child_key_lookup(association)
        association.foreign_key.to_sym rescue nil
      end
      
      def criteria_for_options(options)
        criteria = model.where(options[:conditions])
        criteria = criteria.includes(options[:include]) if options[:include]
        criteria = criteria.limit(options[:limit]) if options[:limit]
        criteria = criteria.all_in(:_id => options[:bulk_ids]) if options[:bulk_ids]
        criteria = criteria.page(options[:page]).per(options[:per]) if options[:page] && options[:per]
        criteria = if options[:sort] && options[:sort_reverse]
          criteria.desc(options[:sort])
        elsif options[:sort]
          criteria.asc(options[:sort])
        else
          criteria
        end
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
    end
  end
end
