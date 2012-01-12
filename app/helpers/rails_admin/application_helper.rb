require 'rails_admin/i18n_support'

module RailsAdmin
  module ApplicationHelper

    include RailsAdmin::I18nSupport

    def authorized?(*args)
      @authorization_adapter.nil? || @authorization_adapter.authorized?(*args)
    end

    # Creative whitespace:
    ViewType   =           Struct.new(:parent,    :type,   :authorization, :path_method)
    VIEW_TYPES = {
      :delete         => ViewType.new(:show,      :object, :delete),
      :history_show     => ViewType.new(:show,      :object, nil,            :history_show),
      :edit           => ViewType.new(:show,      :object, :edit),
      :show           => ViewType.new(:index,     :object, nil),
      :export         => ViewType.new(:index,     :model,  :export),
      :new            => ViewType.new(:index,     :model,  :new),
      :history_index      => ViewType.new(:index,     :model,  nil,            :history_index),
      :index          => ViewType.new(:dashboard, :model,  :index),
      :dashboard      => ViewType.new
    }

    def breadcrumbs_for view, abstract_model, object
      return unless VIEW_TYPES[view]
      views = []
      parent = view
      begin
        views << parent
      end while parent = VIEW_TYPES[parent].parent
      breadcrumbs = views.reverse.map do |v|
        breadcrumb_for v, abstract_model, object, (v==view)
      end
      content_tag(:ul, :class => "breadcrumb") do
        breadcrumbs.join('<span class="divider">/</span>').html_safe
      end
    end

    private

    def breadcrumb_for view, abstract_model, object, active
      vt = VIEW_TYPES[view]
      if authorized?(view, abstract_model, object)
        css_classes = []
        css_classes << "active" if active
        content_tag(:li, :class => css_classes.join(' ')) do
          link_to wording_for(:breadcrumb, :action => view), self.send("#{vt.path_method || view}_path")
        end
      end
    end
  end
end

