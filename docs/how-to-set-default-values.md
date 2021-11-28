# How to set default values

RailsAdmin always adds a blank entry in drop-downs, so if you are adding a new record using Rails Admin, it will be blank by default. To pre-select a default value however, e.g.please do it in your model definition, at initialization time:

```ruby
class Team < ActiveRecord::Base
  ....
  after_initialize do
    if new_record?
      self.color ||= 'red' # be VERY careful with ||= and False values
    end
  end

  def color_enum
    ['white', 'black', 'red', 'green', 'blue']
  end
   ...
end
```

The "after_initialize" hook (or callback) triggers after a model record is instantiated. It will set the color value to 'red' for a new record and will leave it to its current value for an existing record (in the edit view).

## Url Params

If you want to set a default value based on a URL param you can access the `bindings` object. The following example shows how to add a default message using the "message" URL param.

```ruby
config.model Post do
  edit do
    field :message do
      def value
        bindings[:view].params["message"]
      end
    end
  end
end
```

## current_user

Adding <code>current_user</code> as a default value adds an extra challenge. The controller layer knows about <code>current_user</code>, this information is not typically available in the model layer for use by <code>after_initialize</code>. And this is an intentional implication of the MVC architecture.

In RailsAdmin, you can assign a default value of <code>current_user</code> like this:

```ruby
config.model Post do
  edit do
    field :user_id, :hidden do
      default_value do
        bindings[:view]._current_user.id
      end
    end
  end
end
```

This was taken from these discussion threads:

- http://groups.google.com/group/rails_admin/msg/fe588202e4401dc4
- http://groups.google.com/group/rails_admin/msg/5338518c540f9151

One thing to be aware of, RailsAdmin hides :user_id when creating the :user belongs_to association. To get around this issue:

```ruby
config.model Post do
  edit do
    configure :user do
      visible false
    end

    field :user_id, :hidden do
      visible true
      default_value do
        bindings[:view]._current_user.id
      end
    end
  end
end
```

See the response by bbenezech in this issue for a detailed explanation:

https://github.com/railsadminteam/rails_admin/issues/963

Some refinement may be required to avoid resetting the user of an existing item, if that's not desired.
