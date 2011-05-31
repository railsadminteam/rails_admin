require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Export < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        cattr_accessor :default_hidden_fields
        @@default_hidden_fields = []

        def initialize(parent)
          super(parent)
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            if @@default_hidden_fields.include?(f.name)
              f.hide
            end
          end
        end
      end
    end
  end
end
