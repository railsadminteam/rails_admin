require 'rails_admin/adapters/active_record/abstract_object'
module RailsAdmin
  module Adapters
    module Mongoid
      class AbstractObject < RailsAdmin::Adapters::ActiveRecord::AbstractObject
        def initialize(object)
          super
          object.associations.each do |name, association|
            if [:has_many, :references_many].include? association.macro
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name.to_s.singularize}_ids
                  #{name}.map{|item| item.id }
                end

                def #{name.to_s.singularize}_ids=(item_ids)
                  items = Array.wrap(item_ids).map{|item_id| #{name}.klass.find(item_id) rescue nil }.compact
                  if persisted?
                    #{name}.substitute items
                  else
                    items.each do |item|
                      item.update_attribute('#{association.foreign_key}', id)
                    end
                  end
                end
RUBY
            elsif [:has_one, :references_one].include? association.macro
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
      end
    end
  end
end
