**Fields - Column CSS class**

By default each column has a CSS class set according to field's data type. 
`'column_type_name'_field`

In addition, each column has a CSS class based on its name
`'column_name'_field`

Second can customized with:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :created_at do
            css_class "customClass"
          end
        end
      end
    end

This classes will be shown on list, show and edit views. They are part of the API and should not change.
In list views, both header th and td data will receive both classes.

**Fields - Column width**

If you want to set a fixed width for a column in the list view:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name do
            column_width 200
          end
        end
      end
    end

It will use field's css_class to set a width for header and data columns.