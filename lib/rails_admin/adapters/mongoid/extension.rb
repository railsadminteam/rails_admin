module RailsAdmin
  module Adapters
    module Mongoid
      module Extension
        extend ActiveSupport::Concern

        included do
          class_attribute :nested_attributes_options
          self.nested_attributes_options = {}
          class << self
            def rails_admin(&block)
              RailsAdmin.config(self, &block)
            end
            alias_method_chain :accepts_nested_attributes_for, :rails_admin
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

        module ClassMethods
          # Mongoid accepts_nested_attributes_for does not store options in accessible scope,
          # so we intercept the call and store it in instance variable which can be accessed from outside
          def accepts_nested_attributes_for_with_rails_admin(*args)
            options = args.extract_options!
            args.each do |arg|
              self.nested_attributes_options[arg.to_sym] = options.reverse_merge(:allow_destroy=>false, :update_only=>false)
            end
            args << options
            accepts_nested_attributes_for_without_rails_admin(*args)
          end
        end
      end
    end
  end
end
