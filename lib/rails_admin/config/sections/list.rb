require 'rails_admin/config/sections/base'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the list view
      class List < RailsAdmin::Config::Sections::Base
        register_instance_option :filters do
          []
        end

        # Number of items listed per page
        register_instance_option :items_per_page do
          RailsAdmin::Config.default_items_per_page
        end

        register_instance_option :sort_by do
          parent.abstract_model.primary_key
        end

        register_instance_option :sort_reverse? do
          true # By default show latest first
        end

        register_instance_option :scopes do
          []
        end

        register_instance_option :row_css_class do
          ''
        end
      end
    end
  end
end
