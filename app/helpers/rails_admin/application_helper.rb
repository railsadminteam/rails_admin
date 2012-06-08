require 'rails_admin/i18n_support'

module RailsAdmin
  module ApplicationHelper

    include RailsAdmin::I18nSupport

    def authorized?(*args)
      @authorization_adapter.nil? || @authorization_adapter.authorized?(*args)
    end

    def current_action?(action, abstract_model = @abstract_model, object = @object)
      @action.custom_key == action.custom_key && 
      abstract_model.try(:to_param) == @abstract_model.try(:to_param) && 
      (@object.try(:persisted?) ? @object.id == object.try(:id) : !object.try(:persisted?))
    end

    def action(key, abstract_model = nil, object = nil)
      RailsAdmin::Config::Actions.find(key, { :controller => self.controller, :abstract_model => abstract_model, :object => object })
    end

    def actions(scope = :all, abstract_model = nil, object = nil)
      RailsAdmin::Config::Actions.all(scope, { :controller => self.controller, :abstract_model => abstract_model, :object => object })
    end

    def edit_user_link
      return nil unless authorized?(:edit, _current_user.class, _current_user) && _current_user.respond_to?(:email)
      return nil unless abstract_model = RailsAdmin.config(_current_user.class).abstract_model
      return nil unless edit_action = RailsAdmin::Config::Actions.find(:edit, {:controller => self.controller, :abstract_model => abstract_model, :object => _current_user })
      link_to _current_user.email, url_for(:action => edit_action.action_name, :model_name => abstract_model.to_param, :id => _current_user.id, :controller => 'rails_admin/main')
    end

    def wording_for(label, action = @action, abstract_model = @abstract_model, object = @object)
      model_config = abstract_model.try(:config)
      object = abstract_model && object.is_a?(abstract_model.model) ? object : nil
      action = RailsAdmin::Config::Actions.find(action.to_sym) if (action.is_a?(Symbol) || action.is_a?(String))

      I18n.t("admin.actions.#{action.i18n_key}.#{label}",
        :model_label => model_config.try(:label),
        :model_label_plural => model_config.try(:label_plural),
        :object_label => model_config && object.try(model_config.object_label_method)
      )
    end

    def main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(:controller => self.controller)      
      nodes_stack.group_by(&:navigation_label).map do |navigation_label, nodes|

        li_stack = nodes.select{|n| n.parent.nil? || !n.parent.to_s.in?(nodes_stack.map{|c| c.abstract_model.model_name }) }.map do |node|
          %{
            <li data-model="#{node.abstract_model.to_param}">
              <a class="pjax" href="#{url_for(:action => :index, :controller => 'rails_admin/main', :model_name => node.abstract_model.to_param)}">#{node.label_plural}</a>
            </li>
            #{navigation(nodes_stack, nodes_stack.select{|n| n.parent.to_s == node.abstract_model.model_name}, 1)}
          }.html_safe
        end.join.html_safe

        if li_stack.present?
          li_stack = %{<li class='nav-header'>#{navigation_label || t('admin.misc.navigation')}</li>}.html_safe + li_stack
        end

        li_stack
      end.join.html_safe
    end

    def navigation nodes_stack, nodes, level
      nodes.map do |node|
        %{
          <li data-model="#{node.abstract_model.to_param}">
            <a class="pjax nav-level-#{level}" href="#{url_for(:action => :index, :controller => 'rails_admin/main', :model_name => node.abstract_model.to_param)}">#{node.label_plural}</a>
          </li>
          #{navigation(nodes_stack, nodes_stack.select{ |n| n.parent.to_s == node.abstract_model.model_name}, level + 1)}
        }.html_safe
      end.join
    end

    def breadcrumb action = @action, acc = []
      begin
        (parent_actions ||= []) << action
      end while action.breadcrumb_parent && (action = action(*action.breadcrumb_parent))
      parent_actions << action(:dashboard) if parent_actions.last.key != :dashboard # in case chain is interrupted

      content_tag(:ul, :class => "breadcrumb") do
        parent_actions.map do |a|
          am = a.send(:eval, 'bindings[:abstract_model]')
          o = a.send(:eval, 'bindings[:object]')
          content_tag(:li, :class => "#{"active" if current_action?(a, am, o)}") do
            if a.http_methods.include?(:get)
              link_to wording_for(:breadcrumb, a, am, o), { :action => a.action_name, :controller => 'rails_admin/main', :model_name => am.try(:to_param), :id => (o.try(:persisted?) && o.try(:id) || nil) }, :class => 'pjax'
            else
              content_tag(:span, wording_for(:breadcrumb, a, am, o))
            end
          end
        end.reverse.join('<span class="divider">/</span>').html_safe
      end
    end

    # parent => :root, :collection, :member
    def menu_for(parent, abstract_model = nil, object = nil, only_icon = false) # perf matters here (no action view trickery)
      actions = actions(parent, abstract_model, object).select{ |a| a.http_methods.include?(:get) }
      actions.map do |action|
        wording = wording_for(:menu, action)
        %{
          <li title="#{wording if only_icon}" rel="#{'tooltip' if only_icon}" class="icon #{action.key}_#{parent}_link #{'active' if current_action?(action)}">
            <a class="#{action.key == :show_in_app ? '' : 'pjax'}" href="#{url_for({ :action => action.action_name, :controller => 'rails_admin/main', :model_name => abstract_model.try(:to_param), :id => (object.try(:persisted?) && object.try(:id) || nil) })}">
              <i class="#{action.link_icon}"></i>
              <span#{only_icon ? " style='display:none'" : ""}>#{wording}</span>
            </a>
          </li>
        }
      end.join.html_safe
    end

    def bulk_menu abstract_model = @abstract_model
      actions = actions(:bulkable, abstract_model)
      return '' if actions.empty?
      content_tag :li, { :class => 'dropdown', :style => 'float:right' } do
        content_tag(:a, { :class => 'dropdown-toggle', :'data-toggle' => "dropdown", :href => '#' }) { t('admin.misc.bulk_menu_title').html_safe + '<b class="caret"></b>'.html_safe } +
        content_tag(:ul, :class => 'dropdown-menu', :style => 'left:auto; right:0;') do
          actions.map do |action|
            content_tag :li do
              link_to wording_for(:bulk_link, action), '#', :onclick => "jQuery('#bulk_action').val('#{action.action_name}'); jQuery('#bulk_form').submit(); return false;"
            end
          end.join.html_safe
        end
      end
    end
  end
end

