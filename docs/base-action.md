# Base action

_All actions inherit from this one._

### #only

Restrict action to one/more specified model(s):

```ruby
actions do
  index do
    only Player # no other model will have the `index` action visible.
  end

  new do
    only [Player, Comment] # no other model will have the `new` action visible. Note the extra brackets '[]' when there is more than one model.
  end
end
```

Relevant only for model/instance actions, not base actions (like `dashboard`).

### #except

Restrict action from one/more specified model(s):

```ruby
actions do
  index do
    except Player # all other models will have the `index` action visible.
  end

  new do
    except [Player, Comment] # all other models will have the `new` action visible. Note the extra brackets '[]' when there is more than one model.
  end
end
```

Relevant only for model/instance actions, not base actions (like `dashboard`).

[More here](../lib/rails_admin/config/actions/base.rb)
