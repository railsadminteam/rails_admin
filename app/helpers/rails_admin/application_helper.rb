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
      :for_object     => ViewType.new(:show,      :object, nil,            :history_object),
      :edit           => ViewType.new(:show,      :object, :edit),
      :show           => ViewType.new(:index,     :object, nil),
      :export         => ViewType.new(:index,     :model,  :export),
      :new            => ViewType.new(:index,     :model,  :new),
      :for_model      => ViewType.new(:index,     :model,  nil,            :history_model),
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
        config = RailsAdmin.config(abstract_model)
        content_tag(:li, :class => css_classes.join(' ')) do
          path_method = vt.path_method || view
          wording = case view
            when :show
              object.send(config.object_label_method)
            when :index
              config.label_plural
            else
              I18n.t("admin.breadcrumbs.#{view}").capitalize
          end
          link_to wording, self.send("#{path_method}_path")
        end
      end
    end
  end
end

