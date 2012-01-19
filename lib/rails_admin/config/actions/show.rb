module RailsAdmin
  module Config
    module Actions
      class Show < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :member do
          true
        end
        
        register_instance_option :route_fragment do
          ''
        end
        
        register_instance_option :breadcrumb_parent do
          :index
        end
        
        register_instance_option :controller do
          Proc.new do
            render @action.template_name
          end
        end
      end
    end
  end
end
