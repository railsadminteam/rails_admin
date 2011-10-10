require 'rails_admin/i18n_support'

module RailsAdmin
  module ApplicationHelper

    include RailsAdmin::I18nSupport

    def history_output(t)
      return unless t
      if not t.message.downcase.rindex("changed").nil?
        return t.message.downcase + " for #{t.table.capitalize} ##{t.item}"
      else
        return t.message.downcase
      end
    end

    # Given a page count and the current page, we generate a set of pagination
    # links.
    #
    # * We use an inner and outer window into a list of links. For a set of
    # 20 pages with the current page being 10:
    # outer_window:
    #   1 2 ..... 19 20
    # inner_window
    #   5 6 7 8 9 10 11 12 13 14
    #
    # This is totally adjustable, or can be turned off by giving the
    # :inner_window setting a value of nil.
    #
    # * Options
    # :left_cut_label => <em>text_for_cut</em>::
    #    Used when the page numbers need to be cut off to prevent the set of
    #    pagination links from being too long.
    #    Defaults to '&hellip;'
    # :right_cut_label => <em>text_for_cut</em>::
    #    Same as :left_cut_label but for the right side of numbers.
    #    Defaults to '&hellip;'
    # :outer_window => <em>number_of_pages</em>::
    #    Sets the number of pages to include in the outer 'window'
    #    Defaults to 2
    # :inner_window => <em>number_of_pages</em>::
    #    Sets the number of pags to include in the inner 'window'
    #    Defaults to 7
    # :page_param => <em>name_of_page_paramiter</em>
    #    Sets the name of the paramiter the paginator uses to return what
    #    page is being requested.
    #    Defaults to 'page'
    # :url => <em>url_for_links</em>
    #    Provides the base url to use in the page navigation links.
    #    Defaults to ''
    def paginate(current_page, page_count, options = {})
      options[:left_cut_label] ||= '<span>&hellip;</span>'
      options[:right_cut_label] ||= '<span>&hellip;</span>'
      options[:outer_window] ||= 2
      options[:inner_window] ||= 7
      options[:page_param] ||= :page
      options[:url] ||= {}

      pages = {
        :all => (1..page_count).to_a,
        :left => [],
        :center => [],
        :right => []
      }

      infinity = (1/0.0)

      # Only worry about using our 'windows' if the page count is less then
      # our windows combined.
      if options[:inner_window].nil? || ((options[:outer_window] * 2) + options[:inner_window] + 2) >= page_count
        pages[:center] = pages[:all]
      else
        pages[:left] = pages[:all][0, options[:outer_window]]
        pages[:right] = pages[:all][page_count - options[:outer_window], options[:outer_window]]
        pages[:center] = case current_page
        # allow the inner 'window' to shift to right when close to the left edge
        # Ex: 1 2 [3] 4 5 6 7 8 9 ... 20
        when -infinity .. (options[:inner_window] / 2) + 3
          pages[:all][options[:outer_window], options[:inner_window]] +
            [options[:right_cut_label]]
        # allow the inner 'window' to shift left when close to the right edge
        # Ex: 1 2 ... 12 13 14 15 16 [17] 18 19 20
        when (page_count - (options[:inner_window] / 2.0).ceil) - 1 .. infinity
          [options[:left_cut_label]] +
            pages[:all][page_count - options[:inner_window] - options[:outer_window], options[:inner_window]]
        # Display the unshifed window
        # ex: 1 2 ... 5 6 7 [8] 9 10 11 ... 19 20
        else
          [options[:left_cut_label]] +
            pages[:all][current_page - (options[:inner_window] / 2) - 1, options[:inner_window]] +
            [options[:right_cut_label]]
        end
      end

      b = []

      [pages[:left], pages[:center], pages[:right]].each do |p|
        p.each do |page_number|
          css_class = []
          css_class << 'active' if page_number == current_page
          css_class << 'disabled' if page_number.is_a?(String)
          css_class << 'next' if page_number == page_count
          b << content_tag(:li, :class => css_class.join(' ')) do
            if css_class.include?('disabled')
              link_to page_number.to_s.html_safe, 'javascript:'
            else
              link_to page_number, "?" + options[:url].merge(options[:page_param] => page_number).to_query, :remote => options[:remote]
            end
          end
        end
      end

      b.join
    end

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
      :bulk_delete    => ViewType.new(:index,     :model,  :delete),
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

