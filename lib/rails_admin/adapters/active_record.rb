require 'active_record'
require 'rails_admin/config/sections/list'
require 'rails_admin/abstract_object'

module RailsAdmin
  module Adapters
    module ActiveRecord
      DISABLED_COLUMN_TYPES = [:tsvector]
      @@polymorphic_parents = nil
      def self.extended(abstract_model)

        # ActiveRecord does not handle has_one relationships the way it does for has_many,
        # and does not create any association_id and association_id= methods.
        # Added here for backward compatibility after a refactoring, but it does belong to ActiveRecord IMO.
        # Support is hackish at best. Atomicity is respected for creation, but not while updating.
        # It means a failed validation at update on the parent object could still modify target belongs_to foreign ids.
        #
        #
        abstract_model.model.reflect_on_all_associations.select{|assoc| assoc.macro.to_s == 'has_one'}.each do |association|
          abstract_model.model.send(:define_method, "#{association.name}_id") do
            self.send(association.name).try(:id)
          end
          abstract_model.model.send(:define_method, "#{association.name}_id=") do |id|
            self.send(association.name.to_s + '=', associated = (id.blank? ? nil : association.klass.find_by_id(id)))
          end
        end
      end

      def self.polymorphic_parents(name)

        @@polymorphic_parents ||= {}.tap do |hash|
          RailsAdmin::AbstractModel.all_models.each do |klass|
            klass.reflect_on_all_associations.select{|r| r.options[:as] }.each do |reflection|
              (hash[reflection.options[:as]] ||= []) << klass
            end
          end
        end
        @@polymorphic_parents[name.to_sym]
      end

      def get(id)
        if object = model.unscoped.find_by_id(id)
          RailsAdmin::AbstractObject.new object
        else
          nil
        end
      end

      def get_bulk(ids, scope = nil)
        (scope || model).find_all_by_id(ids)
      end

      def count(options = {}, scope = nil)
        (scope || model).count(options.except(:sort, :sort_reverse))
      end

      def first(options = {}, scope = nil)
        (scope || model).reorder(extract_ordering!(options)).first(options)
      end
      
      def all(options = {}, scope = nil)
        (scope || model).reorder(extract_ordering!(options)).all(options)
      end

      def paginated(options = {}, scope = nil)
        page = options.delete(:page) || 1
        per_page = options.delete(:per_page) || RailsAdmin::Config::Sections::List.default_items_per_page

        page_count = (count(options, scope).to_f / per_page).ceil

        options.merge!({
          :limit => per_page,
          :offset => (page - 1) * per_page
        })

        [page_count, all(options, scope)]
      end

      def create(params = {})
        model.create(params)
      end

      def new(params = {})
        RailsAdmin::AbstractObject.new(model.new(params))
      end

      def destroy(ids, scope = nil)
        scope ||= model
        scope.destroy_all(:id => ids)
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
            :parent_model => association_parent_model_lookup(association),
            :parent_key => association_parent_key_lookup(association),
            :child_model => association_child_model_lookup(association),
            :child_key => association_child_key_lookup(association),
            :foreign_type => association_foreign_type_lookup(association),
            :as => association_as_lookup(association),
            :polymorphic => association_polymorphic_lookup(association),
            :inverse_of => association_inverse_of_lookup(association),
            :read_only => association_read_only_lookup(association)
          }
        end
      end

      def polymorphic_associations
        (has_many_associations + has_one_associations).select do |association|
          association[:options][:as]
        end
      end

      def properties
        columns = model.columns.reject {|c| DISABLED_COLUMN_TYPES.include?(c.type.to_sym) }
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

      private

      def extract_ordering!(options)
        @sort ||= options.delete(:sort) || "id"
        @sort = (@sort.to_s.include?('.') ? @sort : "#{model.table_name}.#{@sort}")
        @sort_order ||= options.delete(:sort_reverse) ? "asc" : "desc"
        "#{@sort} #{@sort_order}"
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
