require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Actions
      class Base < RailsAdmin::Config::Base
        include RailsAdmin::Config::Hideable
        
        attr_reader :parent
        @parent = :root # :root, :model, :object
        
        register_instance_option :controller do
          render :action => template_name
        end
        
        register_instance_option :template_name do
          self.class.key
        end
        
        register_instance_option :breadcrumb_i18n_key do
          "admin.breadcrumbs.#{self.class.key}"
        end
        
        register_instance_option :title_i18n_key do
          "admin.titles.#{self.class.key}"
        end
        
        register_instance_option :menu_i18n_key do
          "admin.menus.#{self.class.key}"
        end
        
        # routing related methods should be non-configurable, class-level
        def self.allowed_http_methods
          [:get]
        end
        
        def self.route_fragment_name
          key
        end
        
        def self.controller_method_name
          key
        end
        
        def self.key
          self.name.to_s.demodulize.underscore.to_sym
        end
      end
    end
  end
end
