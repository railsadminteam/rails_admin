`:attr_accessible` and `:attr_protected` are taken into account: restricted fields are not editable (read_only).
If you whitelist attributes, don't forget to whitelist accessible associations' 'id' methods as well : `division_id`, `player_ids`, `commentable_type`, `commentable_id`, etc.

`:attr_accessible` specifies a list of accessible methods for mass-assignment in your ActiveModel models. By default, RailsAdmin uses role `:default` (default in ActiveModel).

If the role you specify isn't used in your whitelist declarations, you'll free access to all attributes.
Keep in mind that `'key' != :key`

You can change role with a block evaluated in the context of the controller (you'll have access to your current_user):

```ruby
RailsAdmin.config do |config|
  config.attr_accessible_role do
    _current_user.roles.first
  end
end
```

If you don't want read_only fields to be visible in your forms:

```ruby
RailsAdmin.config do |config|
  config.models do
    edit do
      fields do
        visible do
          visible && !read_only
        end
      end
    end
  end
end
```

Another example:

```ruby
attr_accessible :email, :password, :password_confirmation, :username, :full_name, :as => [:default, :admin]
attr_accessible :is_admin, as: :admin
```

rails_admin initializer:
```ruby
config.attr_accessible_role { :admin }
```
