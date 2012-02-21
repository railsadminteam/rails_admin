module RailsAdmin
  module Adapters
    module Mongoid
      module Extension
        extend ActiveSupport::Concern

        included do
          def self.rails_admin(&block)
            RailsAdmin::Config.model(self, &block)
          end
        end

        def rails_admin_default_object_label_method
          self.new_record? ? "new #{self.class.to_s}" : "#{self.class.to_s} ##{self.id}"
        end

        def safe_send(value)
          if self.attributes.find{ |k,v| k.to_s == value.to_s }
            self.read_attribute(value)
          else
            self.send(value)
          end
        end
      end
    end
  end
end
