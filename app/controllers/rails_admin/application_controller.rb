require 'rails_admin/abstract_model'

module RailsAdmin
  class ApplicationController < ::ApplicationController
    before_filter :_authenticate!
    before_filter :_authorize!
    before_filter :set_plugin_name

    private

    def _authenticate!
      instance_eval &RailsAdmin.authenticate_with
    end

    def _authorize!
      instance_eval &RailsAdmin.authorize_with
    end

    def set_plugin_name
      @plugin_name = "RailsAdmin"
    end

    def not_found
      render :file => Rails.root.join('public', '404.html'), :layout => false, :status => 404
    end
  end
end
