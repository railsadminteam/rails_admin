# frozen_string_literal: true

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
          [:index, bindings[:abstract_model]]
        end

        register_instance_option :controller do
          proc do
            respond_to do |format|
              format.html { render @action.template_name }
              format.json { render json: @object }
            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-info-circle'
        end
      end
    end
  end
end
