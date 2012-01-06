require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Show < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        @parent = :object
      end
    end
  end
end
