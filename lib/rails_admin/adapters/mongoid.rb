require 'mongoid'
require 'rails_admin/config/sections/list'
require 'rails_admin/abstract_object'

module RailsAdmin
  module Adapters
    module Mongoid
      def self.can_handle_model(model)
        return false unless model.is_a?(Class)

        # calling colletion on an embedded collection just bombs, be a bit more verbose to avoid exception
        is_embedded = model.respond_to?(:embedded) && model.embedded?
        return false if is_embedded

        # check if it's backed by a Mongoid collection
        model.respond_to?(:collection) && model.collection.is_a?(::Mongoid::Collection)
      end

      def get(id)
        if object = model.where(:_id=>BSON::ObjectId(id)).first
          RailsAdmin::AbstractObject.new object
        else
          nil
        end
      end

      def get_bulk(ids)
        model.find(ids)
      end

      def count(options = {})
        model.count(options.reject{|key, value| [:sort, :sort_reverse].include?(key)})
      end

      def first(options = {})
        model.first(merge_order(options))
      end

      def all(options = {})
        Array(model.where(merge_order(options)))
      end

      def paginated(options = {})
        page = options.delete(:page) || 1
        per_page = options.delete(:per_page) || RailsAdmin::Config::Sections::List.default_items_per_page
        sort = options.delete(:sort)
        sort_reverse = options.delete(:sort_reverse)

        page_count = (count(options).to_f / per_page).ceil

        condition = if sort_reverse
          model.where(options).desc(sort)
        else
          model.where(options).asc(sort)
        end

        [page_count, Array(condition.limit(per_page).offset((page-1)*per_page))]
      end

      def create(params = {})
        model.create(params)
      end

      def new(params = {})
        RailsAdmin::AbstractObject.new(model.new)
      end

      def destroy(ids)
        model.destroy(ids)
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

      def model_name
        "todo"
      end

      def associations
        if true
          []
        else
          model.reflect_on_all_associations.select { |association| not association.options[:polymorphic] }.map do |association|
            {
              :name => association.name,
              :pretty_name => association.name.to_s.gsub('_', ' ').capitalize,
              :type => association.macro,
              :parent_model => association_parent_model_lookup(association),
              :parent_key => association_parent_key_lookup(association),
              :child_model => association_child_model_lookup(association),
              :child_key => association_child_key_lookup(association),
            }
          end
        end
      end

      def properties
        model.fields.map do |name,field|
         ar_type =  case field.type.to_s
            when "String"
              :string
            when "Integer"
              :integer
            when "Time"
              :datetime
            when "Float"
              :float
            else
              # this will likely bomb, will fix as it does
              field.type
            end

          {
            :name => field.name.to_sym,
            :pretty_name => field.name.to_s.gsub('_', ' ').capitalize,
            :type => ar_type,
            :length => 100,
            :nullable? => true,
            :serial? => false,
          }
        end
      end

      def model_store_exists?
        # Collections are created on demand, so they always 'exist'.
        # If need to know if pre-exist we can do something like
        #     model.db.collection_names.include?(model.collection.name)
        true
      end

      private

      def merge_order(options)
        @sort ||= options.delete(:sort) || "id"
        @sort_order ||= options.delete(:sort_reverse) ? "asc" : "desc"
        options.merge(:order => "#{@sort} #{@sort_order}")
      end

      def association_parent_model_lookup(association)
        puts "association_parent_model_lookup(#{association})"
        case association.macro
        when :belongs_to
          association.klass
        when :has_one, :has_many, :has_and_belongs_to_many
          association.active_record
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end

      def association_parent_key_lookup(association)
        [:id]
      end

      def association_child_model_lookup(association)
        puts "association_child_model_lookup(#{association})"
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
        puts "association_child_key_lookup(#{association})"
        case association.macro
        when :belongs_to
          [association.options[:foreign_key] || "#{association.name}_id".to_sym]
        when :has_one, :has_many, :has_and_belongs_to_many
          [association.primary_key_name.to_sym]
        else
          raise "Unknown association type: #{association.macro.inspect}"
        end
      end
    end
  end
end
