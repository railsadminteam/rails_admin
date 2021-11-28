## ActiveRecord Enums(Recommended)

RailsAdmin has built-in support for [ActiveRecord's Enum feature](https://api.rubyonrails.org/v5.2.3/classes/ActiveRecord/Enum.html). All you have to do is setting up enums

```ruby
class Player < ActiveRecord::Base
  # keys are string
  enum formation: {start: 'start', substitute: 'substitute'}
end
```

```ruby
class Team < ActiveRecord::Base
  # keys are integer
  enum main_sponsor: [:no_sponsor, :food_factory, :transportation_company, :bank, :energy_producer]
end
```

then RailsAdmin will automatically recognize it as ActiveRecord Enum. Filter feature is also supported.

You can omit type for the fields detected automatically, but if you want to be explicit for field type in configuration, be sure to use `:active_record_enum`.

```ruby
config.model Player do
  field :formation
end
config.model Team do
  field :main_sponsor, :active_record_enum
end
```

`:enum` is the different thing(see the section below) and do not work with ActiveRecord Enum columns.

[More here](../lib/rails_admin/config/fields/types/active_record_enum.rb)

## RailsAdmin Enums(Legacy)

The `:enum` field type is for when you need to display a list of potential values. It will be rendered with a select box in forms.

Other advantage, a **filter** with a select box will be added too.

As usual with RailsAdmin, there are two ways to do this.

### Using the smart default approach

If you have a `:color` column in your Team model, RailsAdmin will check if Team#color_enum exists.
If it does, then you're done.

The result call will be sent to `FormOptionsHelper#options_for_select` to fill the select box.
See [this](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-options_for_select) for possible output (hash, array)

```ruby
class Team < ActiveRecord::Base
  def color_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    ['green', 'white']
    # alternatively
    # { green: 0, white: 1 }
    # [ %w(Green 0), %w(White 1)]
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
    # alternatively,
    # { green: 0, white: 1 }
    # [ %w(Green 0), %w(White 1)]
  end

  # if you need select the default value
  default_value 'green'

  enum do
    # ActiveRecord querys
    except = bindings[:view]._current_user.team_id
    Team.where('id != ?', except).map { |c| [ c.name, c.id ] }
  end
end
```

\*\*\* If you are using enumerator in `has_one` association field, be aware to place `_id` after field's name in RailsAdmin initializer, otherwise you can have problems.

```ruby
field :responsible_id, :enum do
  enum do
    # ...
  end
end

# instead

field :responsible, :enum do
  enum do
    # ...
  end
end
```

### Integration with enum plugins

- The [Enumerize gem](https://github.com/brainspec/enumerize) will automatically generate the appropriate \_enum methods.

- The [bitmask_attributes gem](https://github.com/joelmoss/bitmask_attributes) can be configured this way:

```ruby
    configure :my_mask, :enum do
      enum_method do
        name
      end

      enum do
        Hash[abstract_model.model.bitmasks[name].map { |k,v| [k.humanize.titleize, k] }]
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

- The [mongoid-enum gem](https://github.com/thetron/mongoid-enum) needs a bit of help to play with rails_admin:

```ruby
class Person
  include Mongoid::Document
  include Mongoid::Enum

  # This typical mongoid-enum field definition will add a constant for you. In this case, Person::STATUS
  enum :status, [:living, :dead, :undead]

  rails_admin do
    list do
      # mongoid stores enum fields in a column named with an underscore prefix
      configure :_status, :enum do
        enum { STATUS }
      end
    end
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

[More here](../lib/rails_admin/config/fields/types/enum.rb)
