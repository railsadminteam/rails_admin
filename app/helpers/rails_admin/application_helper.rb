require 'rails_admin/i18n_support'

module RailsAdmin
  module ApplicationHelper

    include RailsAdmin::I18nSupport

    def authorized?(*args)
      @authorization_adapter.nil? || @authorization_adapter.authorized?(*args)
    end
    
    def current_action?(action)
      @action.custom_key == action.custom_key
    end
    
    def breadcrumb action = @action, acc = []
      acc << content_tag(:li, :class => "#{"active" if current_action?(action)}") do
        if authorized?(action.authorization_key, @abstract_model, @object)
          link_to wording_for(:breadcrumb, :action => action.key), { :action => action.action_name }
        else
          content_tag(:span, wording_for(:breadcrumb, :action => action))
        end
      end

      unless action.breadcrumb_parent # rec tail
        content_tag(:ul, :class => "breadcrumb") do
          acc.reverse.join('<span class="divider">/</span>').html_safe
        end
      else
        breadcrumb RailsAdmin::Config::Actions.find(action.breadcrumb_parent), acc # rec
      end
    end
  end
end

