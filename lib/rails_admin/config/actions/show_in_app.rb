module RailsAdmin
  module Config
    module Actions
      class ShowInApp < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :member do
          true
        end
        
        register_instance_option :visible? do
          bindings[:controller].main_app.url_for(bindings[:object]) rescue false
        end
        
        register_instance_option :controller do
          Proc.new do
            redirect_to main_app.url_for(@object)
          end
        end
      end
    end
  end
end
