require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Actions
      class Base < RailsAdmin::Config::Base
        include RailsAdmin::Config::Hideable

        register_instance_option :root_level? do
          false
        end
        
        register_instance_option :model_level? do
          false
        end
          
        register_instance_option :object_level? do
          false
        end
                
        register_instance_option :controller do
          Proc.new do
            render :action => @action.template_name
          end
        end
        
        register_instance_option :bulkable? do
          false
        end
        
        register_instance_option :template_name do
          key.to_sym
        end
        
        register_instance_option :authorization_key do
          key.to_sym
        end
        
        register_instance_option :http_methods do
          [:get]
        end
        
        register_instance_option :route_fragment do
          custom_key.to_s
        end
        
        register_instance_option :action_name do
          custom_key.to_sym
        end
        
        register_instance_option :i18n_key do
          key
        end
        
        # user should override only custom_key (action name and route fragment change, allows for duplicate actions)
        register_instance_option :custom_key do
          key
        end
        
        register_instance_option :breadcrumb_parent do
          case 
          when root_level?
            :dashboard
          when model_level?
            :index
          when object_level?
            :show
          end
        end
        
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
