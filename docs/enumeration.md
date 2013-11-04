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
    # simple array
    ['green', 'white']
  end

  enum do
    # ActiveRecord querys
    Team.last(2).map { |c| [ c.name, c.id ] }
  end
end
```
### Integration with enum plugins

* The [Enumerize gem](https://github.com/brainspec/enumerize) will automatically generate the appropriate _enum methods.

* The [bitmask_attributes gem](https://github.com/joelmoss/bitmask_attributes) can be configured this way:
```ruby
    configure :my_mask, :enum do
      enum_method do
        name
      end

      enum do
        Hash[abstract_model.model.bitmasks[name].map { |k,v| [k.humanize.titleize, v] }]
      end

      pretty_value do
        bindings[:object].send(name).map{|v| v.to_s.humanize.titleize }.join(', ')
      end

      def form_value
        bindings[:object].send(name)
      end

      # set this to true for multi-select
      multiple do
        false
      end
    end
```

### Multi-select ENUM example using User.roles as example...
During Create/Update, display a Multi-Select Widget for :roles field.
Stores/Retrieves the selected options as array into a single db string field as serialized array.

#### model/user.rb
```ruby
class User < ActiveRecord::Base
    serialize :roles, Array
    def roles_enum
        [ [ 'role one', '1' ], [ 'role 2', '2' ], [ 'role 3', '3' ] ]
    end
    def has_role?( role )
        # example called from cancan's app/models/ability.rb
        # if user.has_role?( :ADMIN

        # for roles array stored in db... take each value, see if it matches the second column in the roles_enum array, if so, return the 1st col of the enum as a uprcase,space_to_underscore,symbol .
        assigned_roles = self.roles.map { |r| self.roles_enum.rassoc(r)[0].gsub(/ /, '_').upcase.to_sym }
        assigned_roles.include?( role )
    end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/enum.rb]]