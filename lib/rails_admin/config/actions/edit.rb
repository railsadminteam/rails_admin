

module RailsAdmin
  module Config
    module Actions
      class Edit < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          %i[get put]
        end

        register_instance_option :controller do
          proc do
            if request.get? # EDIT

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, layout: 'rails_admin/modal', content_type: Mime[:html].to_s }
              end

            elsif request.put? # UPDATE
              sanitize_params_for!(request.xhr? ? :modal : :update)

              @object.assign_attributes(params[@abstract_model.param_key])
              @authorization_adapter&.authorize(:update, @abstract_model, @object)
              changes = @object.changes
              if @object.save
                @auditing_adapter&.update_object(@object, @abstract_model, _current_user, changes)
                respond_to do |format|
                  format.html { redirect_to_on_success }
                  format.json { render json: {id: @object.id.to_s, label: @model_config.with(object: @object).object_label} }
                end
              else
                handle_save_error :edit
              end

            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-pencil-alt'
        end

        register_instance_option :writable? do
          !(bindings[:object] && bindings[:object].readonly?)
        end
      end
    end
  end
end
