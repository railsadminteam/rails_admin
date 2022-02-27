# frozen_string_literal: true

module RailsAdmin
  module Adapters
    module ActiveRecord
      module ObjectExtension
        def self.extended(object)
          object.class.reflect_on_all_associations.each do |association|
            association = Association.new(association, object.class)
            case association.type
            when :has_one
              object.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{association.name}_id
                  self.#{association.name}&.id
                end

                def #{association.name}_id=(item_id)
                  self.#{association.name} = (#{association.klass}.find(item_id) rescue nil)
                end
              RUBY
            end
          end
        end

        def assign_attributes(attributes)
          super if attributes
        end
      end
    end
  end
end
