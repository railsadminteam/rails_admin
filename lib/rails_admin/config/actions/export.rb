# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      class Export < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          proc do
            format = params[:json] && :json || params[:csv] && :csv || params[:xml] && :xml
            if format
              request.format = format
              serialization_schema # built while @action is still export
              @schema = serialization_schema.sanitize(params[:schema].slice(:include, :methods, :only).permit!.to_h) if params[:schema]
              @objects = list_entries(@model_config, :export)
              index
            else
              render @action.template_name
            end
          end
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :link_icon do
          'fas fa-file-export'
        end
      end
    end
  end
end
