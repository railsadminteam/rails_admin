require 'rails_admin/adapters/active_record/abstract_object'
module RailsAdmin
  module Adapters
    module Mongoid
      class AbstractObject < RailsAdmin::Adapters::ActiveRecord::AbstractObject
        def initialize(object)
          super
          object.associations.each do |name, association|
            if association.macro == :references_many
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name.to_s.singularize}_ids
                  #{name}.map{|item| item.id }
                end

                def #{name.to_s.singularize}_ids=(item_ids)
                  items = (#{name}.klass.find(Array.wrap(item_ids)) rescue [])
                  if persisted?
                    #{name}.substitute items
                  else
                    items.each do |item|
                      item.update_attribute('#{association.foreign_key}', id)
                    end
                  end
                end
RUBY
            elsif association.macro == :references_one
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name.to_s}_id=(item_id)
                  item = (#{association.klass}.find(item_id) rescue nil)
                  if persisted?
                    self.#{name} = item
                  else
                    item.update_attribute('#{association.foreign_key}', id) if item
                  end
                end
RUBY
            end
          end
        end

        def destroy
          object.destroy
          object
        end
      end
    end
  end
end
