

module RailsAdmin
  module Config
    module Actions
      class New < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          %i[get post] # NEW / CREATE
        end

        register_instance_option :controller do
          proc do
            if request.get? # NEW

              @object = @abstract_model.new
              @action = @action.with(@action.bindings.merge(object: @object))
              @authorization_adapter&.attributes_for(:new, @abstract_model)&.each do |name, value|
                @object.send("#{name}=", value)
              end
              object_params = params[@abstract_model.param_key]
              if object_params
                sanitize_params_for!(request.xhr? ? :modal : :create)
                @object.assign_attributes(@object.attributes.merge(object_params.to_h))
              end
              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, layout: 'rails_admin/modal', content_type: Mime[:html].to_s }
              end

            elsif request.post? # CREATE

              @modified_assoc = []
              @object = @abstract_model.new
              sanitize_params_for!(request.xhr? ? :modal : :create)

              @object.assign_attributes(params[@abstract_model.param_key])
              @authorization_adapter&.authorize(:create, @abstract_model, @object)

              if @object.save
                @auditing_adapter&.create_object(@object, @abstract_model, _current_user)
                respond_to do |format|
                  format.html { redirect_to_on_success }
                  format.json { render json: {id: @object.id.to_s, label: @model_config.with(object: @object).object_label} }
                end
              else
                handle_save_error
              end

            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-plus'
        end

        register_instance_option :writable? do
          !(bindings[:object] && bindings[:object].readonly?)
        end
      end
    end
  end
end
