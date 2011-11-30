require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/fields/group'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the show view for a new object
      class Show < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::HasGroups

        def initialize(parent)
          super(parent)
          # Populate @fields instance variable with model's properties
          @groups = [ RailsAdmin::Config::Fields::Group.new(self, :default) ]
          @groups.first.label do
            I18n.translate("admin.new.basic_info")
          end
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            f.group :default
            if f.serial? || RailsAdmin::Config.default_hidden_fields.include?(f.name)
              f.hide
            end
          end
        end
      end
    end
  end
end
