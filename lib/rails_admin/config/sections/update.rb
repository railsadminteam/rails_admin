require 'rails_admin/config/sections/show'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the edit view for an existing object
      class Update < RailsAdmin::Config::Sections::Show

        def initialize(parent)
          super(parent)
          @fields.each do |f|
            # Hide owning ends of polymorphic associations in edit views as
            # they'd need special handling in RailsAdmin::AbstractObject that
            # has not been implemented
            if f.association? && f.association[:options][:as]
              f.hide
            end
          end
        end

        # Should be a method that's called as bindings[:view].send(@model_config.update.form_builder,...)
        #  e.g.: bindings[:view].send(form_for,...) do |form|
        #           form.text_field(...)
        #        end
        register_instance_option(:form_builder) do
          :form_for
        end
      end
    end
  end
end
