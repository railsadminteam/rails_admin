

require 'rails_admin/config/sections/base'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the list view
      class List < RailsAdmin::Config::Sections::Base
        register_instance_option :checkboxes? do
          true
        end

        register_instance_option :filters do
          []
        end

        # Number of items listed per page
        register_instance_option :items_per_page do
          RailsAdmin::Config.default_items_per_page
        end

        # Positive value shows only prev, next links in pagination.
        # This is for avoiding count(*) query.
        register_instance_option :limited_pagination do
          false
        end

        register_instance_option :search_by do
          nil
        end

        register_instance_option :search_help do
          nil
        end

        register_instance_option :sort_by do
          parent.abstract_model.primary_key
        end

        register_instance_option :scopes do
          []
        end

        register_instance_option :row_css_class do
          ''
        end

        register_deprecated_instance_option :sidescroll do
          ActiveSupport::Deprecation.warn('The sidescroll configuration option was removed, it is always enabled now.')
        end

        def fields_for_table
          visible_fields.partition(&:sticky?).flatten
        end

        register_deprecated_instance_option :sort_reverse do
          ActiveSupport::Deprecation.warn('The sort_reverse configuration option is deprecated and has no effect.')
        end
      end
    end
  end
end
