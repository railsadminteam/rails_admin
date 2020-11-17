require 'rails_admin/config/fields/types/string_like'

module RailsAdmin
  module Config
    module Fields
      module Types
        class FulltextIndexed < StringLike
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_field
          end
        end
      end
    end
  end
end
