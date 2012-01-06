require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Index < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        @parent = :model
        
        def self.allowed_http_methods
          [:get, :post]
        end
      end
    end
  end
end
