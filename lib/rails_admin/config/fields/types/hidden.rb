# frozen_string_literal: true

require 'rails_admin/config/fields/types/string_like'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Hidden < StringLike
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :view_helper do
            :hidden_field
          end

          register_instance_option :label do
            false
          end

          register_instance_option :help do
            false
          end

          def generic_help
            false
          end
        end
      end
    end
  end
end
