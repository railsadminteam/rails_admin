module RailsAdmin
  module Config
    module Actions
      class ShowInApp < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :visible? do
          authorized? && begin
            bindings[:controller].main_app.url_for(bindings[:object])
          rescue StandardError
            false
          end
        end

        register_instance_option :controller do
          proc do
            redirect_to main_app.url_for(@object)
          end
        end

        register_instance_option :link_icon do
          'fas fa-eye'
        end
      end
    end
  end
end
