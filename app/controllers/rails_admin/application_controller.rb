require 'rails_admin/abstract_model'

module RailsAdmin
  class ModelNotFound < ::StandardError
  end

  class ObjectNotFound < ::StandardError
  end

  class ActionNotAllowed < ::StandardError
  end

  class MissingPrimaryKey < ::StandardError
  end

  class ApplicationController < Config.parent_controller.constantize
    protect_from_forgery(Config.forgery_protection_settings)

    before_action :_authenticate!
    before_action :_authorize!
    before_action :_audit!

    helper_method :_current_user, :_get_plugin_name

    attr_reader :object, :model_config, :abstract_model, :authorization_adapter

    def get_model
      @model_name = to_model_name(params[:model_name])
      raise(RailsAdmin::ModelNotFound) unless (@abstract_model = RailsAdmin::AbstractModel.new(@model_name))
      raise(RailsAdmin::ModelNotFound) if (@model_config = @abstract_model.config).excluded?
      raise(RailsAdmin::MissingPrimaryKey) unless @abstract_model.primary_key
      @properties = @abstract_model.properties
    end

    def get_object
      raise(RailsAdmin::ObjectNotFound) unless (@object = @abstract_model.get(params[:id]))
    end

    def to_model_name(param)
      param.split('~').collect(&:camelize).join('::')
    end

    def _current_user
      instance_eval(&RailsAdmin::Config.current_user_method)
    end

  private

    def _get_plugin_name
      @plugin_name_array ||= [RailsAdmin.config.main_app_name.is_a?(Proc) ? instance_eval(&RailsAdmin.config.main_app_name) : RailsAdmin.config.main_app_name].flatten
    end

    def _authenticate!
      instance_eval(&RailsAdmin::Config.authenticate_with)
    end

    def _authorize!
      instance_eval(&RailsAdmin::Config.authorize_with)
    end

    def _audit!
      instance_eval(&RailsAdmin::Config.audit_with)
    end

    def rails_admin_controller?
      true
    end

    rescue_from RailsAdmin::ObjectNotFound do
      set_error_and_action(
        ['admin.flash.object_not_found', model: @model_name, id: params[:id]],
        'index',
      )
      index
    end

    rescue_from RailsAdmin::ModelNotFound do
      set_error_and_action(
        ['admin.flash.model_not_found', model: @model_name],
        'dashboard',
      )
      dashboard
    end

    rescue_from RailsAdmin::MissingPrimaryKey do
      set_error_and_action(
        ['admin.flash.missing_primary_key', model: @model_name],
        'dashboard',
        :method_not_allowed,
      )
      dashboard
    end

    def set_error_and_action(i18n_args, _action, status_code = :not_found)
      flash[:error] = I18n.t(*i18n_args)
      params[:action] = 'action'
      @status_code = status_code
    end
  end
end
