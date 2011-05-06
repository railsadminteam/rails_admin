require 'rails_admin/i18n_support'

module RailsAdmin
  module ApplicationHelper

    include RailsAdmin::I18nSupport

    def head_javascript(path = nil, &block)
      if block
        (@head_javascript ||= []) << capture(&block)
      elsif path
        (@head_javascript_paths ||= []) << path
      else
        html = ""
        if paths = @head_javascript_paths
          html << javascript_include_tag(paths.uniq)
        end
        if script = @head_javascript
          html << javascript_tag(script.join("\n"))
        end
        return html.html_safe
      end
    end

    def head_style(path = nil, &block)
      if block
        (@head_style ||= []) << capture(&block)
      elsif path
        (@head_stylesheet_paths ||= []) << path
      else
        html = ""
        if paths = @head_stylesheet_paths
          html << stylesheet_link_tag(paths.uniq)
        end
        if style = @head_style
          html << content_tag(:style, style.join("\n"), :type => "text/css")
        end
        return html.html_safe
      end
    end

    # A Helper to load from a CDN but with fallbacks in case the primary source is unavailable
    # The best of both worlds - fast clevery cached service from google when available and the
    # ability to work offline too.
    #
    # @example Loading jquery from google
    #   javascript_fallback "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js",
    #     "/javascripts/jquery-1.4.3.min.js",
    #     "typeof jQuery == 'undefined'"
    # @param [String] primary a string to be passed to javascript_include_tag that represents the primary source e.g. A script on googles CDN.
    # @param [String] fallback a path to the secondary javascript file that is (hopefully) more resilliant than the primary.
    # @param [String] test a test written in javascript that evaluates to true if it is necessary to load the fallback javascript.
    # @reurns [String] the resulting html to be inserted into your page.
    def javascript_fallback(primary, fallback, test)
      html = javascript_include_tag( primary )
      html << "\n" << content_tag(:script, :type => "text/javascript") do
        %Q{
          if (#{test}) {
            document.write(unescape("%3Cscript src='#{fallback}' type='text/javascript'%3E%3C/script%3E"));
          }
        }.gsub(/^ {8}/, '').html_safe
      end
      html+"\n"
    end

    def history_output(t)
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
      options[:left_cut_label] ||= '&hellip;'
      options[:right_cut_label] ||= '&hellip;'
      options[:outer_window] ||= 2
      options[:inner_window] ||= 7
      options[:page_param] ||= 'page'
      options[:url] ||= ""

      url = options.delete(:url)
      url.delete(options[:page_param])
      url = url.to_a.collect{|x| x.join("=")}.join("&")

      url += (url.include?('=') ? '&' : '') + options[:page_param]
      url = "?"+url

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

          case page_number
          when String
            b << page_number
          when current_page
            b << Builder::XmlMarkup.new.span(page_number, :class => "this-page")
          when page_count
            b << link_to(page_number, "#{url}=#{page_number}", :class => "end", :remote => true)
          else
            b << link_to(page_number, "#{url}=#{page_number}", :remote => true)
          end
        end
      end

      b.join(" ")
    end

    def authorized?(*args)
      @authorization_adapter.nil? || @authorization_adapter.authorized?(*args)
    end

    # returns a link to "/" unless there's a problem, which will
    # probably be caused by root_path not being configured.  see
    # https://github.com/sferik/rails_admin/issues/345 .
    def home_link
      begin
        link_to(t('home.name'), '/')
      rescue ActionView::Template::Error
        t('home.name')
      end
    end

  end
end
