require 'builder'

module RailsAdmin
  module MainHelper
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
        width = property.column_width || 120

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
        if width = property.column_width
          style[property_type] ||= {:size => 0, :occ => 0, :width => 0}
          style[property_type][:size] += per_property
          style[property_type][:occ] += 1
          style[property_type][:width] = width + style[property_type][:size] / style[property_type][:occ]
        end
      end

      other = []

      if total == 784
        other = ["left", "right"]
      elsif total == 744
        if current_set == 0
          other = ["left"]
        else
          other = ["right"]
        end
      end

      return style, other
    end

  end
end
