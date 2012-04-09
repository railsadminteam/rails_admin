The `:enum` field type is for when you need to display a list of potential values. It will be rendered with a select box in forms.

Other advantage, a **filter** with a select box will be added too.

As usual with RailsAdmin, there are two ways to do this. 

### Using the smart default approach

If you have a `:color` column in your Team model, RailsAdmin will check if Team#color_enum exists.
If it does, then you're done.

The result call will be sent to `FormOptionsHelper#options_for_select` to fill the select box.
See [this](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-options_for_select) for possible output (hash, array)

```ruby
def Team < ActiveRecord::Base
  def color_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    ['green', 'white']
  end
end
```

### Using the configuration approach

```ruby
# you need to tell RailsAdmin that you want to use an `:enum` field
field :color, :enum do 
  # if your model has a method that sends back the options:
  enum_method do
    :my_color_enum_instance_method
  end

  # or doing it directly inline
  enum do
    ['green', 'white']
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/enum.rb]]