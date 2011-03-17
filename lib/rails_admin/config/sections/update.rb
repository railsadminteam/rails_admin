require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/labelable'
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
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        # Default items per page value used if a model level option has not
        # been configured
        cattr_accessor :default_hidden_fields
        @@default_hidden_fields = [:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]

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
            if f.serial? || @@default_hidden_fields.include?(f.name)
              f.hide
            end
          end
        end
      end
    end
  end
end
