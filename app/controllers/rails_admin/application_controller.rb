require 'rails_admin/abstract_model'

module RailsAdmin
  class ApplicationController < ::ApplicationController
    newrelic_ignore if defined?(NewRelic)

    before_filter :_authenticate!
    before_filter :_authorize!

    helper_method :_current_user, :_attr_accessible_role, :_get_plugin_name

    def get_model
      model_name = to_model_name(params[:model_name])
      @abstract_model = RailsAdmin::AbstractModel.new(model_name)
      not_found unless @abstract_model
      @model_config = RailsAdmin.config(@abstract_model)
      not_found if @model_config.excluded?
      @properties = @abstract_model.properties
    end

    def to_model_name(param)
      parts = param.split("~")
      parts[-1] = parts.last.singularize
      parts.map(&:camelize).join("::")
    end

    def get_object
      @object = @abstract_model.get(params[:id])
      not_found unless @object
    end


    private
    def _get_plugin_name
      @plugin_name_array ||= [RailsAdmin.config.main_app_name.is_a?(Proc) ? instance_eval(&RailsAdmin.config.main_app_name) : RailsAdmin.config.main_app_name].flatten
    end

    def _authenticate!
      instance_eval &RailsAdmin::Config.authenticate_with
    end

    def _authorize!
      instance_eval &RailsAdmin::Config.authorize_with
    end

    def _current_user
      instance_eval &RailsAdmin::Config.current_user_method
    end

    def _attr_accessible_role
      instance_eval &RailsAdmin::Config.attr_accessible_role
    end

    def not_found
      render :file => Rails.root.join('public', '404.html'), :layout => false, :status => :not_found
    end

    def rails_admin_controller?
      true
    end
  end
end
