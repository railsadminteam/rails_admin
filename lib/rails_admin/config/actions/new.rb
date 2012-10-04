module RailsAdmin
  module Config
    module Actions
      class New < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :post] # NEW / CREATE
        end

        register_instance_option :controller do

          Proc.new do

            if request.get? # NEW

              @object = @abstract_model.new
              @authorization_adapter && @authorization_adapter.attributes_for(:new, @abstract_model).each do |name, value|
                @object.send("#{name}=", value)
              end
              if object_params = params[@abstract_model.to_param]
                @object.set_attributes(@object.attributes.merge(object_params), _attr_accessible_role)
              end
              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
              end

            elsif request.post? # CREATE

              @modified_assoc = []
              @object = @abstract_model.new
              sanitize_params_for! :create
              
              @object.set_attributes(params[@abstract_model.param_key], _attr_accessible_role)
              @authorization_adapter && @authorization_adapter.attributes_for(:create, @abstract_model).each do |name, value|
                @object.send("#{name}=", value) unless name == :id
              end

              if @object.save
                @auditing_adapter && @auditing_adapter.create_object("Created #{@model_config.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
                respond_to do |format|
                  format.html { redirect_to_on_success }
                  format.js   { render :json => { :id => @object.id, :label => @model_config.with(:object => @object).object_label } }
                end
              else
                handle_save_error
              end

            end
          end
        end

        register_instance_option :link_icon do
          'icon-plus'
        end
      end
    end
  end
end
