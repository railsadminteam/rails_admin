require 'builder'

module RailsAdmin
  module MainHelper

    def history_output(t)
      if not t.message.downcase.rindex("changed").nil?
        return t.message.downcase + " for #{t.table.capitalize} ##{t.item}"
      else
        return t.message.downcase
      end
    end

    def get_indicator(percent)
      percent = 0 if percent.nil?
      return "" if percent.between?(0, 33)
      return "medium" if percent.between?(34, 67)
      return "high" if percent.between?(68, 100)
    end

    def get_column_set(properties)
      sets = calculate_width(properties)
      current_set ||= params[:set].to_i

      raise NotFound if sets.size <= current_set

      selected_set = sets[current_set][:p]
      style, other = justify_properties(sets, current_set)

      return style, other, selected_set
    end

    def object_label(object)
      if object.nil?
        nil
      elsif object.respond_to?(:name) && object.name
        object.name[0..40]
      elsif object.respond_to?(:title) && object.title
        object.title[0..40]
      else
        "#{object.class.to_s} ##{object.id}"
      end
    end

    def format_property(property)
      value = property.value
      return "".html_safe if value.nil?

      case property.type
      when :boolean
        if value == true
          Builder::XmlMarkup.new.img(:src => image_path("bullet_black.png"), :alt => "True").html_safe
        else
          Builder::XmlMarkup.new.img(:src => image_path("bullet_white.png"), :alt => "False").html_safe
        end
      when :datetime, :timestamp
        value.strftime("%b. %d, %Y, %I:%M%p")
      when :date
        value.strftime("%b. %d, %Y")
      when :time
        value.strftime("%I:%M%p")
      when :string
        if property.name.to_s =~ /(image|logo|photo|photograph|picture|thumb|thumbnail)_ur(i|l)/i
          Builder::XmlMarkup.new.img(:src => value, :width => 10, :height => 10).html_safe
        else
          value
        end
      when :text
        value
      when :integer
        value
      else
        value
      end
    end
    
    def object_property(object, property)
      property_type = property[:type]
      property_name = property[:name]
      return "".html_safe if object.send(property_name).nil?

      case property_type
      when :boolean
        if object.send(property_name) == true
          Builder::XmlMarkup.new.img(:src => image_path("bullet_black.png"), :alt => "True").html_safe
        else
          Builder::XmlMarkup.new.img(:src => image_path("bullet_white.png"), :alt => "False").html_safe
        end
      when :datetime, :timestamp
        object.send(property_name).strftime("%b. %d, %Y, %I:%M%p")
      when :date
        object.send(property_name).strftime("%b. %d, %Y")
      when :time
        object.send(property_name).strftime("%I:%M%p")
      when :string
        if property_name.to_s =~ /(image|logo|photo|photograph|picture|thumb|thumbnail)_ur(i|l)/i
          Builder::XmlMarkup.new.img(:src => object.send(property_name), :width => 10, :height => 10).html_safe
        else
          object.send(property_name)
        end
      when :text
        object.send(property_name)
      when :integer
        if association = @abstract_model.belongs_to_associations.select{|a| a[:child_key].first == property_name}.first
          object_label(object.send(association[:name]))
        else
          object.send(property_name)
        end
      else
        object.send(property_name)
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
      url = url.to_a.collect{|x| x.join("=")}.join("&")

      url += (url.include?('=') ? '&' : '') + options[:page_param]
      url = "?"+url

      pages = {
        :all => (1..page_count).to_a,
        :left => [],
        :center => [],
        :right => []
      }

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
            b << Builder::XmlMarkup.new.a(page_number, :class => "end", :href => "#{url}=#{page_number}")
          else
            b << Builder::XmlMarkup.new.a(page_number, :href => "#{url}=#{page_number}")
          end
        end
      end

      b.join(" ")
    end

    private

    def infinity
      1.0 / 0
    end

    def calculate_width(properties)
      # local variables
      total = 0
      set = []

      # variables used in loop
      partial_total = 0
      temp = []

      # loop through properties
      properties.each do |property|
        # get width for the current property
        width = property.column_width

        # if properties that were gathered so far have the width
        # over 697 make a set for them
        if partial_total + width >= 697
          set << {:p => temp, :size => partial_total}
          partial_total = 0
          temp = []
        end

        # continue to add properties to set
        temp << property
        partial_total += width
        total += width
      end

      # add final set to returned value
      set << {:p => temp, :size => partial_total}

      return set
    end

    def justify_properties(sets, current_set)
      total = 697
      style = {}

      properties = sets[current_set][:p]
      # calculate the maximum distance
      total = sets.size == 1 ? 784 : 744
      max_sets = sets.size-2
      total = current_set.between?(1, max_sets) ?  704 : total
      column_offset = total-sets[current_set][:size]
      per_property = column_offset/properties.size
      offset = column_offset - per_property * properties.size

      properties.each do |property|
        property_type = property.column_css_class
        property_width = property.column_width
        style[property_type] ||= {:size => 0, :occ => 0, :width => 0}
        style[property_type][:size] += per_property
        style[property_type][:occ] += 1
        style[property_type][:width] = property_width + style[property_type][:size] / style[property_type][:occ]
      end

      other = []

      if total == 784
        other = ["otherHeaderLeft", "otherHeaderRight", "otherLeft", "otherRight"]
      elsif total == 744
        if current_set == 0
          other = ["otherHeaderLeft", "otherLeft"]
        else
          other = ["otherHeaderRight", "otherRight"]
        end
      end

      return style, other
    end

  end
end
