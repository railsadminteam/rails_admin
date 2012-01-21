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
    
    def action(key, abstract_model = nil, object = nil)
      action = RailsAdmin::Config::Actions.find(key, { :controller => self.controller, :abstract_model => abstract_model, :object => object })
      action && authorized?(action.authorization_key, (action.collection? || action.member?) && abstract_model || nil, action.member? && object || nil) ? action : nil
    end
    
    def actions(scope = :all, abstract_model = nil, object = nil)
      RailsAdmin::Config::Actions.all(scope, { :controller => self.controller, :abstract_model => abstract_model, :object => object }).select do |action|
        authorized?(action.authorization_key, (action.collection? || action.member?) && abstract_model || nil, action.member? && object || nil)
      end
    end
    
    def edit_user_link
      return nil unless authorized?(:edit, _current_user.class, _current_user) && _current_user.respond_to?(:email)
      return nil unless abstract_model = RailsAdmin.config(_current_user.class).abstract_model
      return nil unless edit_action = RailsAdmin::Config::Actions.find(:edit, {:controller => self.controller, :abstract_model => abstract_model, :object => _current_user })
      link_to _current_user.email, url_for(:action => edit_action.action_name, :model_name => abstract_model.to_param, :id => _current_user.id, :controller => 'rails_admin/main')
    end

    
    def wording_for(label, action = @action, abstract_model = @abstract_model, object = @object)
      
      model_config = abstract_model && RailsAdmin.config(abstract_model)
      object = abstract_model && object.is_a?(abstract_model.model) ? object : nil
      action = RailsAdmin::Config::Actions.find(action.to_sym) if (action.is_a?(Symbol) || action.is_a?(String))
      
      I18n.t("admin.actions.#{action.i18n_key}.#{label}", 
        :model_label => model_config.try(:label), 
        :model_label_plural => model_config.try(:label_plural), 
        :object_label => model_config && object.try(model_config.object_label_method)
      )
    end
    
    def breadcrumb action = @action, acc = []
      
      acc << content_tag(:li, :class => "#{"active" if current_action?(action)}") do
        if action.http_methods.include?(:get)
          link_to wording_for(:breadcrumb, action), { :action => action.action_name, :controller => 'rails_admin/main' }
        else
          content_tag(:span, wording_for(:breadcrumb, action))
        end
      end

      unless action.breadcrumb_parent && (parent = action(action.breadcrumb_parent, @abstract_model, @object)) # rec tail
        content_tag(:ul, :class => "breadcrumb") do
          acc.reverse.join('<span class="divider">/</span>').html_safe
        end
      else
        breadcrumb parent, acc # rec
      end
    end
    
    # parent => :root, :collection, :member
    def menu_for(parent, abstract_model = nil, object = nil) # perf matters here (no action view trickery)
      actions = actions(parent, abstract_model, object).select{ |action| action.http_methods.include?(:get) }
      actions.map do |action|
        %{
          <li class="#{action.key}_#{parent}_link #{'active' if current_action?(action)}">
            <a href="#{url_for({ :action => action.action_name, :controller => 'rails_admin/main', :model_name => abstract_model.try(:to_param), :id => object.try(:id) })}">
              #{wording_for(:menu, action)}
            </a>
          </li>
        }
      end.join.html_safe
    end
    
    def bulk_menu abstract_model = @abstract_model
      actions = actions(:bulkable, abstract_model)
      return '' if actions.empty?
      content_tag :li, { :class => 'dropdown', :style => 'float:right', :'data-dropdown' => "dropdown" } do
        content_tag(:a, { :class => 'dropdown-toggle', :href => '#' }) { t('admin.misc.bulk_menu_title') } +
        content_tag(:ul, :class => 'dropdown-menu') do
          actions.map do |action|
            content_tag :li do
              link_to_function wording_for(:bulk_link, action), "jQuery('#bulk_action').val('#{action.action_name}'); jQuery('#bulk_form').submit()"
            end
          end.join.html_safe
        end
      end
    end
  end
end

