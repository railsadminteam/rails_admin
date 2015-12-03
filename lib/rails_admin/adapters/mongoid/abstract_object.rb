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
                  __items__ = Array.wrap(item_ids).map{|item_id| #{name}.klass.find(item_id) rescue nil }.compact
                  unless persisted?
                    __items__.each do |item|
                      item.update_attribute('#{association.foreign_key}', id)
                    end
                  end
                  super __items__.map(&:id)
                end
RUBY
            elsif [:has_one, :references_one].include? association.macro
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name}_id=(item_id)
                  item = (#{association.klass}.find(item_id) rescue nil)
                  return unless item
                  unless persisted?
                    item.update_attribute('#{association.foreign_key}', id)
                  end
                  super item.id
                end
RUBY
            end
          end
        end
      end
    end
  end
end
