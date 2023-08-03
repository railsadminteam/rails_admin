## Fields - Column CSS class

By default each column has a CSS class set according to field's data type.
`<field_type>_field`

In addition, each column has a CSS class based on its name
`<field_name>_field`

Field name CSS class can customized with:

```ruby
RailsAdmin.config do |config|
  config.model Team do
    list do
      field :created_at do
        css_class "customClass"
      end
    end
  end
end
```

This classes will be shown on list, show and edit views. They are part of the API and should not change.
In list views, both header th and td data will receive both classes.

## Fields - Column width

If you want to set a fixed width for a column in the list view:

```ruby
RailsAdmin.config do |config|
  config.model Team do
    list do
      field :name do
        column_width 200
      end
    end
  end
end
```

Use this to configure lists table width:

```ruby
RailsAdmin.config do |config|
  config.total_columns_width = 1000
end
```

It will use field's name CSS class to set a width for header and data columns.

Also see how to [show all fields on one page in a horizontally-scrolling table](horizontally-scrolling-table-with-frozen-columns-in-list-view.md).
