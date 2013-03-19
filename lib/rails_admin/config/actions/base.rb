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

        # http://twitter.github.com/bootstrap/base-css.html#icons
        register_instance_option :link_icon do
          'icon-question-sign'
        end

        # Should the action be visible
        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :authorized? do
          (
            bindings[:controller].nil? or bindings[:controller].authorized?(self.authorization_key, bindings[:abstract_model], bindings[:object])
          ) and (
            bindings[:abstract_model].nil? or (
              (only.nil? or [only].flatten.map(&:to_s).include?(bindings[:abstract_model].to_s)) and
              ![except].flatten.map(&:to_s).include?(bindings[:abstract_model].to_s) and
              bindings[:abstract_model].config.with(bindings).visible?
          ))
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
          Proc.new do
            render :action => @action.template_name
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

        # For Cancan and the like
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
          case
          when root?
            [:dashboard]
          when collection?
            [:index, bindings[:abstract_model]]
          when member?
            [:show, bindings[:abstract_model], bindings[:object]]
          end
        end

        # Off API.

        def key
          self.class.key
        end

        def self.key
          self.name.to_s.demodulize.underscore.to_sym
        end
      end
    end
  end
end
