require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Export < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields

        def self.default_hidden_fields
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields' is deprecated, use 'RailsAdmin::Config.default_hidden_fields_for_export' instead", caller)
          RailsAdmin::Config.default_hidden_fields_for_export
        end

        def self.default_hidden_fields=(value)
          ActiveSupport::Deprecation.warn("'#{self.name}.default_hidden_fields=' is deprecated, use 'RailsAdmin.config{|c| c.default_hidden_fields_for_export = #{value}}' instead", caller)
          RailsAdmin.config do |config|
            config.default_hidden_fields_for_export = value
          end
        end

        def initialize(parent)
          super(parent)
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            if RailsAdmin::Config.default_hidden_fields_for_export.include?(f.name)
              f.hide
            end
          end
        end
      end
    end
  end
end
