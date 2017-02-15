An easy way to render the show view of objects as a table is to create a custom show template:

```ruby
# app/views/rails_admin/main/show.html.slim

css:
  body.rails_admin table.table-details tr th {
    max-width: 6ex;
    font-weight: normal;
    color: #666;
  }

  table.table-details tr td, table.table-details tr th {
    border: none;
  }

- @model_config.show.with(object: @object, view: self, controller: self.controller).visible_groups.each do |fieldset|
  - unless (fields = fieldset.with(object: @object, view: self, controller: self.controller).visible_fields).empty?
    - if !(values = fields.map{ |f| f.formatted_value.presence }).compact.empty? || !RailsAdmin::config.compact_show_view
      table.table.table-striped.table-hover.table-details
        - fields.each_with_index do |field, index|
          - unless values[index].nil? && RailsAdmin::config.compact_show_view
            tr
              th
                = field.label
              td
                = field.pretty_value
```