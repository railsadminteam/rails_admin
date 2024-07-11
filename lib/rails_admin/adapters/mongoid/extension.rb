

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

            alias_method :accepts_nested_attributes_for_without_rails_admin, :accepts_nested_attributes_for
            alias_method :accepts_nested_attributes_for, :accepts_nested_attributes_for_with_rails_admin
          end
        end

        def rails_admin_default_object_label_method
          new_record? ? "new #{self.class}" : "#{self.class} ##{id}"
        end

        def safe_send(value)
          if attributes.detect { |k, _v| k.to_s == value.to_s }
            read_attribute(value)
          else
            send(value)
          end
        end

        module ClassMethods
          # Mongoid accepts_nested_attributes_for does not store options in accessible scope,
          # so we intercept the call and store it in instance variable which can be accessed from outside
          def accepts_nested_attributes_for_with_rails_admin(*args)
            options = args.extract_options!
            args.each do |arg|
              nested_attributes_options[arg.to_sym] = options.reverse_merge(allow_destroy: false, update_only: false)
            end
            args << options
            accepts_nested_attributes_for_without_rails_admin(*args)
          end
        end
      end
    end
  end
end
