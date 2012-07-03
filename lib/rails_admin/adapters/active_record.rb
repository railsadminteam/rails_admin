require 'active_record'
require 'rails_admin/adapters/active_record/abstract_object'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = [:tsvector, :blob, :binary, :spatial, :hstore]

      def ar_adapter
        Rails.configuration.database_configuration[Rails.env]['adapter']
      end

      def like_operator
        ar_adapter == "postgresql" ? 'ILIKE' : 'LIKE'
      end

      def new(params = {})
        AbstractObject.new(model.new(params))
      end

      def get(id)
        if object = model.where(model.primary_key => id).first
          AbstractObject.new object
        else
          nil
        end
      end

      def scoped
        model.scoped
      end

      def first(options = {}, scope = nil)
        all(options, scope).first
      end

      def all(options = {}, scope = nil)
        scope ||= self.scoped
        scope = scope.includes(options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.where(model.primary_key => options[:bulk_ids]) if options[:bulk_ids]
        scope = scope.where(query_conditions(options[:query])) if options[:query]
        scope = scope.where(filter_conditions(options[:filters])) if options[:filters]
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

      def primary_key
        model.primary_key
      end

      def associations
        model.reflect_on_all_associations.map do |association|
          {
            :name => association.name.to_sym,
            :pretty_name => association.name.to_s.tr('_', ' ').capitalize,
            :type => association.macro,
            :model_proc => Proc.new { association_model_lookup(association) },
            :primary_key_proc => Proc.new { association_primary_key_lookup(association) },
            :foreign_key => association_foreign_key_lookup(association),
            :foreign_type => association_foreign_type_lookup(association),
            :as => association_as_lookup(association),
            :polymorphic => association_polymorphic_lookup(association),
            :inverse_of => association_inverse_of_lookup(association),
            :read_only => association_read_only_lookup(association),
            :nested_form => association_nested_attributes_options_lookup(association)
          }
        end
      end

      def properties
        columns = model.columns.reject {|c| c.type.blank? || DISABLED_COLUMN_TYPES.include?(c.type.to_sym) }
        columns.map do |property|
          {
            :name => property.name.to_sym,
            :pretty_name => property.name.to_s.tr('_', ' ').capitalize,
            :type => property.type,
            :length => property.limit,
            :nullable? => property.null,
            :serial? => property.primary,
          }
        end
      end

      def table_name
        model.table_name
      end

      def serialized_attributes
        model.serialized_attributes.keys
      end

      def encoding
        Rails.configuration.database_configuration[Rails.env]['encoding']
      end

      def embedded?
        false
      end

      private

      def query_conditions(query, fields = config.list.fields.select(&:queryable?))
        statements = []
        values = []

        fields.each do |field|
          field.searchable_columns.flatten.each do |column_infos|
            statement, value1, value2 = build_statement(column_infos[:column], column_infos[:type], query, field.search_operator)
            statements << statement if statement
            values << value1 unless value1.nil?
            values << value2 unless value2.nil?
          end
        end

        [statements.join(' OR '), *values]
      end

      # filters example => {"string_field"=>{"0055"=>{"o"=>"like", "v"=>"test_value"}}, ...}
      # "0055" is the filter index, no use here. o is the operator, v the value
      def filter_conditions(filters, fields = config.list.fields.select(&:filterable?))
        statements = []
        values = []

        filters.each_pair do |field_name, filters_dump|
          filters_dump.each do |filter_index, filter_dump|
            field_statements = []
            fields.find{|f| f.name.to_s == field_name}.searchable_columns.each do |column_infos|
              statement, value1, value2 = build_statement(column_infos[:column], column_infos[:type], filter_dump[:v], (filter_dump[:o] || 'default'))
              field_statements << statement if statement.present?
              values << value1 unless value1.nil?
              values << value2 unless value2.nil?
            end
            statements << "(#{field_statements.join(' OR ')})" unless field_statements.empty?
          end
        end

        [statements.join(' AND '), *values]
      end

      def build_statement(column, type, value, operator)
        # this operator/value has been discarded (but kept in the dom to override the one stored in the various links of the page)
        return if operator == '_discard' || value == '_discard'

        # filtering data with unary operator, not type dependent
        if operator == '_blank' || value == '_blank'
          return ["(#{column} IS NULL OR #{column} = '')"]
        elsif operator == '_present' || value == '_present'
          return ["(#{column} IS NOT NULL AND #{column} != '')"]
        elsif operator == '_null' || value == '_null'
          return ["(#{column} IS NULL)"]
        elsif operator == '_not_null' || value == '_not_null'
          return ["(#{column} IS NOT NULL)"]
        elsif operator == '_empty' || value == '_empty'
          return ["(#{column} = '')"]
        elsif operator == '_not_empty' || value == '_not_empty'
          return ["(#{column} != '')"]
        end

        # now we go type specific
        case type
        when :boolean
          return ["(#{column} IS NULL OR #{column} = ?)", false] if ['false', 'f', '0'].include?(value)
          return ["(#{column} = ?)", true] if ['true', 't', '1'].include?(value)
        when :decimal
          return if value.blank?
          ["(#{column} = ?)", value.to_f] if value.to_f.to_s == value
        when :integer, :belongs_to_association
          return if value.blank?
          ["(#{column} = ?)", value.to_i] if value.to_i.to_s == value
        when :string, :text
          return if value.blank?
          value = case operator
          when 'default', 'like'
            "%#{value}%"
          when 'starts_with'
            "#{value}%"
          when 'ends_with'
            "%#{value}"
          when 'is', '='
            "#{value}"
          else
            return
          end
          ["(#{column} #{like_operator} ?)", value]
        when :date
          start_date, end_date = get_filtering_duration(operator, value)

          if start_date && end_date
            ["(#{column} BETWEEN ? AND ?)", start_date, end_date]
          elsif start_date
            ["(#{column} >= ?)", start_date]
          elsif end_date
            ["(#{column} <= ?)", end_date]
          end
        when :datetime, :timestamp
          start_date, end_date = get_filtering_duration(operator, value)

          if start_date && end_date
            ["(#{column} BETWEEN ? AND ?)", start_date.to_time.beginning_of_day, end_date.to_time.end_of_day]
          elsif start_date
            ["(#{column} >= ?)", start_date.to_time.beginning_of_day]
          elsif end_date
            ["(#{column} <= ?)", end_date.to_time.end_of_day]
          end
        when :enum
          return if value.blank?
          ["(#{column} IN (?))", Array.wrap(value)]
        end
      end

      def association_model_lookup(association)
        if association.options[:polymorphic]
          RailsAdmin::AbstractModel.polymorphic_parents(:active_record, association.name) || []
        else
          association.klass
        end
      end

      def association_foreign_type_lookup(association)
        if association.options[:polymorphic]
          association.options[:foreign_type].try(:to_sym) || :"#{association.name}_type"
        end
      end

      def association_nested_attributes_options_lookup(association)
        model.nested_attributes_options.try { |o| o[association.name.to_sym] }
      end

      def association_as_lookup(association)
        association.options[:as].try :to_sym
      end

      def association_polymorphic_lookup(association)
        !!association.options[:polymorphic]
      end

      def association_primary_key_lookup(association)
        association.options[:primary_key] || association.klass.primary_key
      end

      def association_inverse_of_lookup(association)
        association.options[:inverse_of].try :to_sym
      end

      def association_read_only_lookup(association)
        association.options[:readonly]
      end

      def association_foreign_key_lookup(association)
        association.foreign_key.to_sym
      end
    end
  end
end
