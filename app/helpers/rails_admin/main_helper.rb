require 'builder'

module RailsAdmin
  module MainHelper
    def get_indicator(percent)
      return "" if percent < 0          # none
      return "notice" if percent < 34   # < 1/100 of max
      return "success" if percent < 67  # < 1/10 of max
      return "warning" if percent < 84  # < 1/3 of max
      return "important"                # > 1/3 of max
    end
    
    def get_column_sets(properties)
      sets = []
      property_index = 0
      set_index = 0
      
      while (property_index < properties.length)
        current_set_width = 0
        begin
          sets[set_index] ||= []
          sets[set_index] << properties[property_index]
          current_set_width += (properties[property_index].column_width || 120)
          property_index += 1
        end while (current_set_width < RailsAdmin::Config.total_columns_width) && (property_index < properties.length)
        set_index += 1
      end
      sets
    end
  end
end
