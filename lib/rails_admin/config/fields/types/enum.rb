require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Enum < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:partial) do
            :form_enumeration
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil} enum",
              :value => value
            }
          end

          register_instance_option(:enum_method) do
            @enum_method ||= bindings[:object].respond_to?("#{name}_enum") ? "#{name}_enum" : name
          end

          register_instance_option(:enum) do
            bindings[:object].send(self.enum_method)
          end

          register_instance_option(:pretty_value) do
            if enum.is_a?(Hash)
              enum.reject{|k,v| v.to_s != value.to_s}.keys.first.to_s.presence || value.to_s
            elsif enum.is_a?(Array) && enum.first.is_a?(Array)
              enum.find{|e|e[1].to_s == value.to_s}.try(:first).to_s.presence || value.to_s
            else
              value.to_s
            end
          end
        end
      end
    end
  end
end
