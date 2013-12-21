require 'builder'

module RailsAdmin
  module MainHelper
    def rails_admin_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => RailsAdmin::FormBuilder)
      form_for(*(args << options), &block) << after_nested_form_callbacks
    end

    def get_indicator(percent)
      case percent
      when  0...34 then 'info'
      when 34...67 then 'success'
      when 67...84 then 'warning'
      when 84..100 then 'danger'
      else ''
      end
    end

    def get_column_sets(properties)
      sets = []
      property_index = 0
      set_index = 0

      while property_index < properties.length
        current_set_width = 0
        loop do
          sets[set_index] ||= []
          sets[set_index] << properties[property_index]
          current_set_width += (properties[property_index].column_width || 120)
          property_index += 1
          break unless current_set_width < RailsAdmin::Config.total_columns_width && property_index < properties.length
        end
        set_index += 1
      end
      sets
    end
  end
end
