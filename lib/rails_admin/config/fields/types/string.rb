require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class String < RailsAdmin::Config::Fields::Base

          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :text_field
          
          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
              :maxlength => length,
              :size => [50, length.to_i].min,
              :style => "width:#{column_width}px",
              :value => value,
            }
           end
          
          register_instance_option(:help) do
            text = (required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")) + '. '
            text += "#{length} #{length == 1 ? I18n.translate("admin.new.one_char") : I18n.translate("admin.new.many_chars")}." if length.present?
            text
          end

          register_instance_option(:partial) do
            :form_field
          end
        end
      end
    end
  end
end
