

module RailsAdmin
  module ApplicationHelper
    def authorized?(action_name, abstract_model = nil, object = nil)
      object = nil if object.try :new_record?
      action(action_name, abstract_model, object).try(:authorized?)
    end

    def current_action?(action, abstract_model = @abstract_model, object = @object)
      @action.custom_key == action.custom_key &&
        abstract_model.try(:to_param) == @abstract_model.try(:to_param) &&
        (@object.try(:persisted?) ? @object.id == object.try(:id) : !object.try(:persisted?))
    end

    def action(key, abstract_model = nil, object = nil)
      RailsAdmin::Config::Actions.find(key, controller: controller, abstract_model: abstract_model, object: object)
    end

    def actions(scope = :all, abstract_model = nil, object = nil)
      RailsAdmin::Config::Actions.all(scope, controller: controller, abstract_model: abstract_model, object: object)
    end

    def edit_user_link
      return nil unless _current_user.try(:email).present?
      return nil unless (abstract_model = RailsAdmin.config(_current_user.class).abstract_model)

      edit_action = action(:edit, abstract_model, _current_user)
      authorized = edit_action.try(:authorized?)
      content = edit_user_link_label

      if authorized
        edit_url = rails_admin.url_for(
          action: edit_action.action_name,
          model_name: abstract_model.to_param,
          controller: 'rails_admin/main',
          id: _current_user.id,
        )

        link_to content, edit_url, class: 'nav-link'
      else
        content_tag :span, content, class: 'nav-link'
      end
    end

    def logout_path
      if defined?(Devise)
        scope = Devise::Mapping.find_scope!(_current_user)
        begin
          main_app.send("destroy_#{scope}_session_path")
        rescue StandardError
          false
        end
      elsif main_app.respond_to?(:logout_path)
        main_app.logout_path
      end
    end

    def logout_method
      return [Devise.sign_out_via].flatten.first if defined?(Devise)

      :delete
    end

    def wording_for(label, action = @action, abstract_model = @abstract_model, object = @object)
      model_config = abstract_model.try(:config)
      object = nil unless abstract_model && object.is_a?(abstract_model.model)
      action = RailsAdmin::Config::Actions.find(action.to_sym) if action.is_a?(Symbol) || action.is_a?(String)

      I18n.t(
        "admin.actions.#{action.i18n_key}.#{label}",
        model_label: model_config&.label,
        model_label_plural: model_config&.label_plural,
        object_label: model_config && object.try(model_config.object_label_method),
      )
    end

    def main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }
      parent_groups = nodes_stack.group_by { |n| n.parent&.to_s }

      nodes_stack.group_by(&:navigation_label).collect do |navigation_label, nodes|
        nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
        li_stack = navigation parent_groups, nodes

        label = navigation_label || t('admin.misc.navigation')

        collapsible_stack(label, 'main', li_stack)
      end.join.html_safe
    end

    def root_navigation
      actions(:root).select(&:show_in_sidebar).group_by(&:sidebar_label).collect do |label, nodes|
        li_stack = nodes.map do |node|
          url = rails_admin.url_for(action: node.action_name, controller: 'rails_admin/main')
          nav_icon = node.link_icon ? %(<i class="#{node.link_icon}"></i>).html_safe : ''
          content_tag :li do
            link_to nav_icon + " " + wording_for(:menu, node), url, class: "nav-link"
          end
        end.join.html_safe
        label ||= t('admin.misc.root_navigation')

        collapsible_stack(label, 'action', li_stack)
      end.join.html_safe
    end

    def static_navigation
      li_stack = RailsAdmin::Config.navigation_static_links.collect do |title, url|
        content_tag(:li, link_to(title.to_s, url, target: '_blank', rel: 'noopener noreferrer', class: 'nav-link'))
      end.join.html_safe

      label = RailsAdmin::Config.navigation_static_label || t('admin.misc.navigation_static_label')
      collapsible_stack(label, 'static', li_stack) || ''
    end

    def navigation(parent_groups, nodes, level = 0)
      nodes.collect do |node|
        abstract_model = node.abstract_model
        model_param = abstract_model.to_param
        url         = rails_admin.url_for(action: :index, controller: 'rails_admin/main', model_name: model_param)
        nav_icon = node.navigation_icon ? %(<i class="#{node.navigation_icon}"></i>).html_safe : ''
        css_classes = ['nav-link']
        css_classes.push("nav-level-#{level}") if level > 0
        css_classes.push('active') if @action && current_action?(@action, model_param)
        li = content_tag :li, data: {model: model_param} do
          link_to nav_icon + " " + node.label_plural, url, class: css_classes.join(' ')
        end
        child_nodes = parent_groups[abstract_model.model_name]
        child_nodes ? li + navigation(parent_groups, child_nodes, level + 1) : li
      end.join.html_safe
    end

    def breadcrumb(action = @action, _acc = [])
      begin
        (parent_actions ||= []) << action
      end while action.breadcrumb_parent && (action = action(*action.breadcrumb_parent)) # rubocop:disable Lint/Loop

      content_tag(:ol, class: 'breadcrumb') do
        parent_actions.collect do |a|
          am = a.send(:eval, 'bindings[:abstract_model]')
          o = a.send(:eval, 'bindings[:object]')
          content_tag(:li, class: ['breadcrumb-item', current_action?(a, am, o) && 'active']) do
            if current_action?(a, am, o)
              wording_for(:breadcrumb, a, am, o)
            elsif a.http_methods.include?(:get)
              link_to rails_admin.url_for(action: a.action_name, controller: 'rails_admin/main', model_name: am.try(:to_param), id: (o.try(:persisted?) && o.try(:id) || nil)) do
                wording_for(:breadcrumb, a, am, o)
              end
            else
              content_tag(:span, wording_for(:breadcrumb, a, am, o))
            end
          end
        end.reverse.join.html_safe
      end
    end

    # parent => :root, :collection, :member
    # perf matters here (no action view trickery)
    def menu_for(parent, abstract_model = nil, object = nil, only_icon = false)
      actions = actions(parent, abstract_model, object).select { |a| a.http_methods.include?(:get) && a.show_in_menu }
      actions.collect do |action|
        wording = wording_for(:menu, action)
        li_class = ['nav-item', 'icon', "#{action.key}_#{parent}_link"].
                   concat(action.enabled? ? [] : ['disabled'])
        content_tag(:li, {class: li_class}.merge(only_icon ? {title: wording, rel: 'tooltip'} : {})) do
          label = content_tag(:i, '', {class: action.link_icon}) + ' ' + content_tag(:span, wording, (only_icon ? {style: 'display:none'} : {}))
          if action.enabled? || !only_icon
            href =
              if action.enabled?
                rails_admin.url_for(action: action.action_name, controller: 'rails_admin/main', model_name: abstract_model.try(:to_param), id: (object.try(:persisted?) && object.try(:id) || nil))
              else
                'javascript:void(0)'
              end
            content_tag(:a, label, {href: href, target: action.link_target, class: ['nav-link', current_action?(action) && 'active', !action.enabled? && 'disabled'].compact}.merge(action.turbo? ? {} : {data: {turbo: 'false'}}))
          else
            content_tag(:span, label)
          end
        end
      end.join(' ').html_safe
    end

    def bulk_menu(abstract_model = @abstract_model)
      actions = actions(:bulkable, abstract_model)
      return '' if actions.empty?

      content_tag :li, class: 'nav-item dropdown dropdown-menu-end' do
        content_tag(:a, class: 'nav-link dropdown-toggle', data: {'bs-toggle': 'dropdown'}, href: '#') { t('admin.misc.bulk_menu_title').html_safe + ' ' + '<b class="caret"></b>'.html_safe } +
          content_tag(:ul, class: 'dropdown-menu', style: 'left:auto; right:0;') do
            actions.collect do |action|
              content_tag :li do
                link_to wording_for(:bulk_link, action, abstract_model), '#', class: 'dropdown-item bulk-link', data: {action: action.action_name}
              end
            end.join.html_safe
          end
      end.html_safe
    end

    def flash_alert_class(flash_key)
      case flash_key.to_s
      when 'error'  then 'alert-danger'
      when 'alert'  then 'alert-warning'
      when 'notice' then 'alert-info'
      else "alert-#{flash_key}"
      end
    end

    def handle_asset_dependency_error
      yield
    rescue LoadError => e
      if /sassc/.match?(e.message)
        e = e.exception <<~MSG
          #{e.message}
          RailsAdmin requires the gem sassc-rails, make sure to put `gem 'sassc-rails'` to Gemfile.
        MSG
      end
      raise e
    end

    # Workaround for https://github.com/rails/rails/issues/31325
    def image_tag(source, options = {})
      if %w[ActiveStorage::Variant ActiveStorage::VariantWithRecord ActiveStorage::Preview].include? source.class.to_s
        super main_app.route_for(ActiveStorage.resolve_model_to_route, source), options
      else
        super
      end
    end

  private

    def edit_user_link_label
      [
        RailsAdmin::Config.show_gravatar &&
          image_tag(gravatar_url(_current_user.email), alt: ''),

        content_tag(:span, _current_user.email),
      ].filter(&:present?).join.html_safe
    end

    def gravatar_url(email)
      "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest email}?s=30"
    end

    def collapsible_stack(label, class_prefix, li_stack)
      return nil unless li_stack.present?

      collapse_classname = "#{class_prefix}-#{Digest::MD5.hexdigest(label)[0..7]}"
      content_tag(:li, class: 'mb-1') do
        content_tag(:button, 'aria-expanded': true, class: 'btn btn-toggle align-items-center rounded', data: {bs_toggle: "collapse", bs_target: ".sidebar .#{collapse_classname}"}) do
          content_tag(:i, '', class: 'fas fa-chevron-down') + html_escape(' ' + label)
        end +
          content_tag(:div, class: "collapse show #{collapse_classname}") do
            content_tag(:ul, class: 'btn-toggle-nav list-unstyled fw-normal pb-1') do
              li_stack
            end
          end
      end
    end
  end
end
