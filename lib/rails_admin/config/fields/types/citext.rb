

require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Citext < Text
          RailsAdmin::Config::Fields::Types.register(:citext, self)
        end
      end
    end
  end
end
