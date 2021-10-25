module RailsAdmin
  module Adapters
    module Mongoid
      module ObjectExtension
        def self.extended(object)
          object.associations.each do |name, association|
            association = Association.new(association, object.class)
            case association.macro
            when :has_many
              unless association.autosave?
                object.singleton_class.after_create do
                  send(name).each(&:save)
                end
              end
            when :has_one
              unless association.autosave?
                object.singleton_class.after_create do
                  send(name)&.save
                end
              end
              object.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name}_id=(item_id)
                  self.#{name} = (#{association.klass}.find(item_id) rescue nil)
                end
              RUBY
            end
          end
        end
      end
    end
  end
end
