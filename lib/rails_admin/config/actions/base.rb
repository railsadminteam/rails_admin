require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Actions
      class Base
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable
        include RailsAdmin::Config::Hideable

        register_instance_option :only do
          nil
        end

        register_instance_option :except do
          []
        end

        register_instance_option :show_in_navigation do
          root?
        end

        register_instance_option :show_in_sidebar do
          !show_in_navigation
        end

        register_instance_option :show_in_menu do
          true
        end

        register_instance_option :sidebar_label do
          nil
        end

        # http://getbootstrap.com/2.3.2/base-css.html#icons
        register_instance_option :link_icon do
          'icon-question-sign'
        end

        # Should the action be visible
        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :enabled? do
          bindings[:abstract_model].nil? || (
            (only.nil? || [only].flatten.collect(&:to_s).include?(bindings[:abstract_model].to_s)) &&
            ![except].flatten.collect(&:to_s).include?(bindings[:abstract_model].to_s) &&
            !bindings[:abstract_model].config.excluded?
          )
        end

        register_instance_option :authorized? do
          enabled? && (
            bindings[:controller].try(:authorization_adapter).nil? || bindings[:controller].authorization_adapter.authorized?(authorization_key, bindings[:abstract_model], bindings[:object])
          )
        end

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        # Is the action on a model scope (Example: /admin/team/export)
        register_instance_option :collection? do
          false
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          false
        end

        # Render via pjax?
        register_instance_option :pjax? do
          true
        end

        # This block is evaluated in the context of the controller when action is called
        # You can access:
        # - @objects if you're on a model scope
        # - @abstract_model & @model_config if you're on a model or object scope
        # - @object if you're on an object scope
        register_instance_option :controller do
          proc do
            render action: @action.template_name
          end
        end

        # Model scoped actions only. You will need to handle params[:bulk_ids] in controller
        register_instance_option :bulkable? do
          false
        end

        # View partial name (called in default :controller block)
        register_instance_option :template_name do
          key.to_sym
        end

        # For CanCanCan and the like
        register_instance_option :authorization_key do
          key.to_sym
        end

        # List of methods allowed. Note that you are responsible for correctly handling them in :controller block
        register_instance_option :http_methods do
          [:get]
        end

        # Url fragment
        register_instance_option :route_fragment do
          custom_key.to_s
        end

        # Controller action name
        register_instance_option :action_name do
          custom_key.to_sym
        end

        # I18n key
        register_instance_option :i18n_key do
          key
        end

        # User should override only custom_key (action name and route fragment change, allows for duplicate actions)
        register_instance_option :custom_key do
          key
        end

        # Breadcrumb parent
        register_instance_option :breadcrumb_parent do
          if root?
            [:dashboard]
          elsif collection?
            [:index, bindings[:abstract_model]]
          elsif member?
            [:show, bindings[:abstract_model], bindings[:object]]
          end
        end

        # Off API.

        def key
          self.class.key
        end

        def self.key
          name.to_s.demodulize.underscore.to_sym
        end
      end
    end
  end
end
