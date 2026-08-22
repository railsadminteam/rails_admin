Suppose you want to track who created a project so you want to set current_user to the field user_id. You could do this in `app/models/project.rb`:

```ruby
rails_admin do
  edit do
    field :user, :hidden do
      visible false
      default_value do
        bindings[:view]._current_user.id
      end
    end
  end
end
```

This only hides the field and sets the default value, but this default value can be overriden in POST request which means it is not secure. So instead use your ability file to do this:

```ruby
can :create, Project, user_id: user.id if user
```
