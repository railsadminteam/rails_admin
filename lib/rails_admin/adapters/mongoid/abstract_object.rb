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

                def #{name.to_s.singularize}_ids=(items)
                  self.#{name} = items.
                    map{|item_id| self.#{name}.klass.find(item_id) rescue nil }.
                    compact
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
