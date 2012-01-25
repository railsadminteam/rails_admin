require 'active_record'
require 'rails_admin/config/sections/list'
require 'rails_admin/abstract_object'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = [:tsvector, :blob, :binary]
      @@polymorphic_parents = nil

      def self.polymorphic_parents(name)
        @@polymorphic_parents ||= {}.tap do |hash|
          RailsAdmin::AbstractModel.all_models.each do |klass|
            klass.reflect_on_all_associations.select{|r| r.options[:as] }.each do |reflection|
              (hash[reflection.options[:as].to_sym] ||= []) << klass
            end
          end
        end
        @@polymorphic_parents[name.to_sym]
      end

      def get(id)
        if object = model.where(model.primary_key => id).first
          RailsAdmin::AbstractObject.new object
        else
          nil
        end
      end

      def count(options = {}, scope = nil)
        all(options.merge({:limit => false, :page => false}), scope).count
      end

      def first(options = {}, scope = nil)
        all(options, scope).first
      end

      def all(options = {}, scope = nil)
        scope ||= self.scoped
        scope = scope.includes(options[:include]) if options[:include]
        scope = scope.limit(options[:limit]) if options[:limit]
        scope = scope.where(model.primary_key => options[:bulk_ids]) if options[:bulk_ids]
        scope = scope.where(options[:conditions]) if options[:conditions]
        scope = scope.page(options[:page]).per(options[:per]) if options[:page] && options[:per]
        scope = scope.reorder("#{options[:sort]} #{options[:sort_reverse] ? 'asc' : 'desc'}") if options[:sort]
        scope
      end

      def scoped
        model.scoped
      end

      def create(params = {})
        model.create(params)
      end

      def new(params = {})
        RailsAdmin::AbstractObject.new(model.new(params))
      end

      def destroy(objects)
        [objects].flatten.map &:destroy
      end

      def destroy_all!
        model.all.each do |object|
          object.destroy
        end
      end

      def has_and_belongs_to_many_associations
        associations.select do |association|
          association[:type] == :has_and_belongs_to_many
        end
      end

      def has_many_associations
        associations.select do |association|
          association[:type] == :has_many
        end
      end

      def has_one_associations
        associations.select do |association|
          association[:type] == :has_one
        end
      end

      def belongs_to_associations
        associations.select do |association|
          association[:type] == :belongs_to
        end
      end

      def associations
        model.reflect_on_all_associations.map do |association|
          {
            :name => association.name.to_sym,
            :pretty_name => association.name.to_s.tr('_', ' ').capitalize,
            :type => association.macro,
            :parent_model_proc => Proc.new { association_parent_model_lookup(association) },
            :parent_key => association_parent_key_lookup(association),
            :child_model_proc => Proc.new { association_child_model_lookup(association) },
            :child_key => association_child_key_lookup(association),
            :foreign_type => association_foreign_type_lookup(association),
            :as => association_as_lookup(association),
            :polymorphic => association_polymorphic_lookup(association),
            :inverse_of => association_inverse_of_lookup(association),
            :read_only => association_read_only_lookup(association),
            :nested_form => association_nested_attributes_options_lookup(association)
          }
        end
      end

      def polymorphic_associations
        (has_many_associations + has_one_associations).select do |association|
          association[:options][:as]
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

      def model_store_exists?
        model.table_exists?
      end

      def get_conditions_hash(model_config, query, filters)
        @like_operator =  "ILIKE" if ::ActiveRecord::Base.configurations[Rails.env]['adapter'] == "postgresql"
        @like_operator ||= "LIKE"

        query_statements = []
        filters_statements = []
        values = []
        conditions = [""]

        if query.present?
          queryable_fields = model_config.list.fields.select(&:queryable?)
          queryable_fields.each do |field|
            searchable_columns = field.searchable_columns.flatten
            searchable_columns.each do |field_infos|
              statement, value1, value2 = build_statement(field_infos[:column], field_infos[:type], query, field.search_operator)
              if statement
                query_statements << statement
                values << value1 unless value1.nil?
                values << value2 unless value2.nil?
              end
            end
          end
        end

        unless query_statements.empty?
          conditions[0] += " AND " unless conditions == [""]
          conditions[0] += "(#{query_statements.join(" OR ")})"
        end

        if filters.present?
          @filterable_fields = model_config.list.fields.select(&:filterable?).inject({}){ |memo, field| memo[field.name.to_sym] = field.searchable_columns; memo }
          filters.each_pair do |field_name, filters_dump|
            filters_dump.each do |filter_index, filter_dump|
              field_statements = []
              @filterable_fields[field_name.to_sym].each do |field_infos|
                statement, value1, value2 = build_statement(field_infos[:column], field_infos[:type], filter_dump[:v], (filter_dump[:o] || 'default'))
                if statement
                  field_statements << statement
                  values << value1 unless value1.nil?
                  values << value2 unless value2.nil?
                end
              end
              filters_statements << "(#{field_statements.join(' OR ')})" unless field_statements.empty?
            end
          end
        end

        unless filters_statements.empty?
         conditions[0] += " AND " unless conditions == [""]
         conditions[0] += "#{filters_statements.join(" AND ")}" # filters should all be true
        end

        conditions += values
        conditions != [""] ? { :conditions => conditions } : {}
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
          end
          ["(#{column} #{@like_operator} ?)", value]
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
          ["(#{column} BETWEEN ? AND ?)", *values]
        when :enum
          return if value.blank?
          ["(#{column} IN (?))", [value].flatten]
        end
      end

      def association_options(association)
        if association.options[:polymorphic]
          {
            :polymorphic => true,
            :foreign_type => association.options[:foreign_type] || "#{association.name}_type"
          }
        elsif association.options[:as]
          {
            :as => association.options[:as]
          }
        else
          {}
        end
      end

      def association_parent_model_lookup(association)
        case association.macro
        when :belongs_to
          if association.options[:polymorphic]
            RailsAdmin::Adapters::ActiveRecord.polymorphic_parents(association.name) || []
          else
            association.klass
          end
        when :has_one, :has_many, :has_and_belongs_to_many
          association.active_record
        else
          raise "Unknown association type: #{association.macro.inspect}"
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
        association.options[:polymorphic]
      end

      def association_parent_key_lookup(association)
        [:id]
      end

      def association_inverse_of_lookup(association)
        association.options[:inverse_of].try :to_sym
      end

      def association_read_only_lookup(association)
        association.options[:readonly]
      end

      def association_child_model_lookup(association)
        case association.macro
        when :belongs_to
          association.active_record
        when :has_one, :has_many, :has_and_belongs_to_many
          association.klass
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end

      def association_child_key_lookup(association)
        case association.macro
        when :belongs_to
          association.options[:foreign_key].try(:to_sym) || "#{association.name}_id".to_sym
        when :has_one, :has_many, :has_and_belongs_to_many
          association.foreign_key.to_sym
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end
    end
  end
end
