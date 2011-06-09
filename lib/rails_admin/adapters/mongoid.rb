require 'mongoid'
require 'rails_admin/config/sections/list'
require 'rails_admin/abstract_object'
require 'rails_admin/adapters/abstract_object_mongoid'

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

      def self.extend(abstract_model)
        abstract_model.model.send(:define_method, :rails_admin_default_object_label_method) do 
          "#{self.class.to_s} ##{self.try :id}"
        end
      end

      def get(id)
        if object = model.where(:_id=>BSON::ObjectId(id)).first
          RailsAdmin::Adapters::AbstractObjectMongoid.new object
        else
          nil
        end
      end

      def get_bulk(ids,scope=nil)
        ids = ids.map{|i| BSON::ObjectId(i)}        
        Array(model.where(:_id.in=>ids))
      end

      def keys
        [:_id]
      end

      def count(options = {},scope=nil)
        criteria_for_options(options).count
      end

      def first(options = {},scope=nil)
        criteria_for_options(options).first
      end

      def all(options = {},scope=nil)
        criteria_for_options(options)
      end
      
      def paginated(options = {},scope=nil)
        page = options.delete(:page) || 1
        per_page = options.delete(:per_page) || RailsAdmin::Config::Sections::List.default_items_per_page
        criteria = criteria_for_options(options)

        page_count = (criteria.count.to_f / per_page).ceil


        [page_count, Array(criteria.limit(per_page).offset((page-1)*per_page))]
      end

      def create(params = {})
        model.create(params)
      end

      def new(params = {})
        RailsAdmin::AbstractObject.new(model.new)
      end

      def destroy(ids)
        ids = ids.map{|i| BSON::ObjectId(i)}
        destroyed = Array(model.where(:_id.in=>ids))
        model.destroy_all(:conditions=>{:_id.in=>ids})
        destroyed
      end

      def destroy_all!
        model.destroy_all
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

      def polymorphic_associations
      end

      def model_name
        "todo"
      end 
      
      def table_name
        model.collection.name
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
        @properties if @properties
        @properties = model.fields.map do |name,field|
          ar_type =  case field.type.to_s
                     when "Array"
                       :string
                     when "Array"
                       :string
                     when "BigDecimal"
                       :string
                     when "Boolean"
                       :boolean
                     when "Date"
                       :datetime
                     when "DateTime"
                       :datetime
                     when "Float"
                       :float
                     when "Hash"
                       :string
                     when "Integer"
                       :integer
                     when "String"
                       :string
                     when "Time"
                       :datetime
                     when "BSON::ObjectId"
                       :bson_object_id
                     when "Object"
                       :bson_object_id
                     else
                       raise "Need to map field #{field.type.to_s} for field name #{name} in #{model.inspect}"
                     end

          {
            :name => field.name.to_sym,
            :pretty_name => field.name.to_s.gsub('_', ' ').strip.capitalize,
            :type => ar_type,
            :length => 1024,
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
        [:_id]
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
      
      private

      def criteria_for_search(options)
        # get the wanted string as the last argument and remove the percent signs
        wanted = Regexp.new(options[:conditions][1][1..-2])
        model.any_of(properties.select{|p| p[:type]==:string}.map{|p| {p[:name].to_sym=>wanted}})
      end
      
      def criteria_for_options(options)
        sort = options.delete(:sort)
        sort_reverse = options.delete(:sort_reverse)
        # detect a LIKE condition 
        criteria = if options && options[:conditions] && options[:conditions][0][' LIKE ']
                     criteria_for_search(options)
                   else
                     model.where(options)
                   end
        criteria = if sort && sort_reverse
          criteria.desc(sort)
        elsif sort 
          criteria.asc(sort)
        else
          criteria
        end
      end

      
    end
  end
end
