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

        register_instance_option :sidescroll do
          nil
        end

        def horizontal_scroll_list_calc
          global_config = RailsAdmin::Config.sidescroll
          model_config = sidescroll
          enabled = model_config == false ? false : (!!model_config || !!global_config)
          if enabled
            num_frozen = model_config[:num_frozen_columns] if model_config.is_a?(Hash)
            unless num_frozen
              num_frozen = global_config[:num_frozen_columns] if global_config.is_a?(Hash)
              num_frozen ||= 3 # by default, freeze checkboxes, links & first property (usually primary key / id?)
              num_frozen -= 1 unless checkboxes? # model config should be explicit about this, only adjust if using global config
            end
          else
            num_frozen = 0
          end
          {
            enabled: enabled,
            num_frozen_columns: num_frozen,
          }
        end
      end
    end
  end
end
