

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
            end
          end
        end
      end
    end
  end
end
