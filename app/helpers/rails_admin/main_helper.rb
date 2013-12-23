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

    def get_sort_hash(model_config)
      abstract_model = model_config.abstract_model
      params[:sort] = params[:sort_reverse] = nil unless model_config.list.fields.map { |f| f.name.to_s }.include? params[:sort]

      params[:sort] ||= model_config.list.sort_by.to_s
      params[:sort_reverse] ||= 'false'

      field = model_config.list.fields.detect { |f| f.name.to_s == params[:sort] }

      column = if field.nil? || field.sortable == true # use params[:sort] on the base table
                 "#{abstract_model.table_name}.#{params[:sort]}"
               elsif field.sortable == false # use default sort, asked field is not sortable
                 "#{abstract_model.table_name}.#{model_config.list.sort_by}"
               elsif (field.sortable.is_a?(String) || field.sortable.is_a?(Symbol)) && field.sortable.to_s.include?('.') # just provide sortable, don't do anything smart
                 field.sortable
               elsif field.sortable.is_a?(Hash) # just join sortable hash, don't do anything smart
                 "#{field.sortable.keys.first}.#{field.sortable.values.first}"
               elsif field.association? # use column on target table
                 "#{field.associated_model_config.abstract_model.table_name}.#{field.sortable}"
               else # use described column in the field conf.
                 "#{abstract_model.table_name}.#{field.sortable}"
               end

      reversed_sort = (field ? field.sort_reverse? : model_config.list.sort_reverse?)
      {:sort => column, :sort_reverse => (params[:sort_reverse] == reversed_sort.to_s)}
    end
  end
end
