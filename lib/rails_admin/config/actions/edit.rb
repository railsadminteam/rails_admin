require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Edit < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        @parent = :object
        
        def self.allowed_http_methods
          [:get, :put]
        end
      end
    end
  end
end
