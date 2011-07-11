require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/fields/group'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the edit view for an existing object
      class Update < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::HasGroups

        def self.default_hidden_fields
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields' is deprecated, use 'RailsAdmin::Config.default_hidden_fields_for_edit' instead", caller)
          RailsAdmin::Config.default_hidden_fields_for_edit
        end

        def self.default_hidden_fields=(value)
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields=' is deprecated, use 'RailsAdmin.config{|c| c.default_hidden_fields_for_edit = #{value}}' instead", caller)
          RailsAdmin.config do |config|
            config.default_hidden_fields_for_edit = value
          end
        end

        def initialize(parent)
          super(parent)
          # Populate @fields instance variable with model's properties
          @groups = [ RailsAdmin::Config::Fields::Group.new(self, :default) ]
          @groups.first.label do
            I18n.translate("admin.new.basic_info")
          end
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            if f.association? && f.type != :belongs_to_association
              f.group f.label.to_sym
            else
              f.group :default
            end
            # Hide owning ends of polymorphic associations in edit views as
            # they'd need special handling in RailsAdmin::AbstractObject that
            # has not been implemented
            if f.association? && f.association[:options][:as]
              f.hide
            end
            if f.serial? || RailsAdmin::Config.default_hidden_fields_for_edit.include?(f.name)
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
