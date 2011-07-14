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

        def self.default_hidden_fields
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields' is deprecated, use 'RailsAdmin::Config.default_hidden_fields' instead", caller)
          RailsAdmin::Config.default_hidden_fields
        end

        def self.default_hidden_fields=(value)
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields=' is deprecated, use 'RailsAdmin.config{|c| c.default_hidden_fields = #{value}}' instead", caller)
          RailsAdmin.config do |config|
            config.default_hidden_fields = value
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
            if f.serial? || RailsAdmin::Config.default_hidden_fields.include?(f.name)
              f.hide
            end
          end
        end
      end
    end
  end
end
