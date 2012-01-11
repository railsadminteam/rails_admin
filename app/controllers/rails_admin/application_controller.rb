require 'rails_admin/abstract_model'

module RailsAdmin
  class ModelNotFound < ::StandardError
  end
  
  class ObjectNotFound < ::StandardError
  end
  
  class ApplicationController < ::ApplicationController
    newrelic_ignore if defined?(NewRelic)

    before_filter :_authenticate!
    before_filter :_authorize!
    before_filter :_audit!

    helper_method :_current_user, :_attr_accessible_role, :_get_plugin_name

    def get_model
      @model_name = to_model_name(params[:model_name])
      @abstract_model = RailsAdmin::AbstractModel.new(@model_name) rescue begin
        raise RailsAdmin::ModelNotFound
      end
      @model_config = RailsAdmin.config(@abstract_model)
      raise(RailsAdmin::ModelNotFound) if @model_config.excluded?
      @properties = @abstract_model.properties
    end
    
    def get_object
      unless (@object = @abstract_model.get(params[:id]))
        raise RailsAdmin::ObjectNotFound
      end
    end

    def to_model_name(param)
      model_name = to_model_name_with_singularize(param)
      presented_model_name?(model_name) ? model_name : to_model_name_without_singularize(param)
    end

    def to_model_name_without_singularize(param)
      parts = param.split("~")
      parts.map(&:camelize).join("::")
    end

    def to_model_name_with_singularize(param)
      parts = param.split("~")
      parts[-1] = parts.last.singularize
      parts.map(&:camelize).join("::")
    end

    def presented_model_name?(model_name)
      !RailsAdmin::AbstractModel.lookup(model_name).nil?
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
    
    def _audit!
      instance_eval &RailsAdmin::Config.audit_with
    end

    def _current_user
      instance_eval &RailsAdmin::Config.current_user_method
    end

    def _attr_accessible_role
      instance_eval &RailsAdmin::Config.attr_accessible_role
    end
    
    rescue_from RailsAdmin::ObjectNotFound do
      flash[:error] = I18n.t('admin.flash.object_not_found', :model => @model_name, :id => params[:id])
      params[:action] = 'index'
      index
    end
    
    rescue_from RailsAdmin::ModelNotFound do
      flash[:error] = I18n.t('admin.flash.model_not_found', :model => @model_name)
      params[:action] = 'dashboard'
      dashboard
    end
    
    def not_found
      render :file => Rails.root.join('public', '404.html'), :layout => false, :status => :not_found
    end

    def rails_admin_controller?
      true
    end
  end
end
