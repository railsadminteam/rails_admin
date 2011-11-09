The `:enum` field type is for when you need to display a list of potential values. It will be rendered with a select box in forms.

Other advantage, a filter with a select box will be added too.

As usual with RailsAdmin, there are two ways to do this. 

## Using the smart default approach

If you have a `:country` column in your Article model, RailsAdmin will check if Article#country_enum exists.
If it does, then you're done.

The result call will be sent to `FormOptionsHelper#options_for_select` to fill the select box.
See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-options_for_select

Do not select any value, or add any blank field.

Example:

```ruby
def Article
  def country_enum
    [['us', 'United States'], ['fr', 'France']]
  end
end
```

## Using the configuration approach

```ruby
field :color, :enum do
  # if your model has a method that sends back the options:
  enum_method do
    :my_color_enum_instance_method
  end

  # or doing it inline
  enum do
    ['green', 'white']
  end
end
```