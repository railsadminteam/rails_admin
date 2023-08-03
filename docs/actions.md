## Default

Actions used to be static and hard-coded. A community request was that they could be added/removed/customized.

This is now possible.

By default, to keep existing installation safe, all actions are added as they used to be.

Default is equivalent to:

```ruby
# config/initializers/rails_admin.rb
RailsAdmin.config do |config|
  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
  end
end
```

## Use existing actions and customize them

Simply list them and pass an optional block, like so:

```ruby
config.actions do
  dashboard do
    i18n_key :dash
  end
  index
  new
end
```

Please note that `dashboard` and `index` are mandatory for the moment, but this may change in the future.

## Define actions

- `root` defines root level actions (Dashboard, etc.)
- `collection` defines collection level actions (Index, New, etc.)
- `member` defines member level actions (Show, Edit, etc.)

First argument is the key of the action.
It will be the `i18n_key`, the `route_fragment`, the `action_name`, the `authorization_key`, etc.
You can override each of these individually. See the respective class and the [Base Action class](../lib/rails_admin/config/actions/base.rb) to get the list of these options.

Second (optional) argument is the key of the parent class. It can be any existing Action class. If none given, it will be `Base`.

Then you can pass the configuration block.

Then add `app/views/rails_admin/main/my_action.html.<erb|haml>` in your application, where you will be able to access:

- `@abstract_model` (except for root actions, give the RailsAdmin representation of the model. Use .model to have your ActiveRecord original model)
- `@model_config` (except for root actions, give the RailsAdmin configuration of the model)
- `@objects = list_entries` (for collection actions, list the entries as specified in params, see the :index action and template)
- `@object` (member actions only, ActiveRecord object)

```ruby
config.actions do
  root :my_dashboard, :dashboard          # subclass Dashboard. Accessible at /admin/my_dashboard
  collection :my_collection_action do     # subclass Base. Accessible at /admin/<model_name>/my_collection_action
    ...
  end
  member :my_member_action do             # subclass Base. Accessible at /admin/<model_name>/<id>/my_member_action
    i18n_key :edit                        # will have the same menu/title labels as the Edit action.
  end
end

```

## Create a reusable action

```ruby
# somewhere in your lib/ directory:

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class MyAction < RailsAdmin::Config::Actions::Base
         RailsAdmin::Config::Actions.register(self)
         register_instance_option :my_option do
           :default_value
         end
      end
    end
  end
end

# use it like this:

config.actions do
  my_action do
    my_option :another_value
  end
end
```

If you want to share it as a gem, see [custom action](custom-action.md).

## Action wording for title, menu, breadcrumb and links

Default I18n key is action name underscored. You can change it like so:

```ruby
config.actions do
  dashboard do
    i18n_key :customized
  end
  ...
end
```

Then head for your `config/locales/rails_admin.xx.yml` file:

```yaml
xx:
  admin:
    actions:
      <customized>:
        title: "..."
        menu: "..."
        breadcrumb: "..."
        link: "..."
```

See [rails_admin.en.yml](../config/locales/rails_admin.en.yml) to get an idea.

Actions can provide specific option configuration, check their respective wiki page.

## Controlling visibility

### Through authorization

Authorization is done automatically before any link is displayed, any page accessed, etc.
Check [CanCanCan](cancancan.md) for the list of key used by RailsAdmin default actions.

You can change the authorization key with:

```ruby
config.actions do
  dashboard do
    authorization_key :customized
  end
  ...
end
```

### Per-model basis

```ruby
config.actions do
  edit do
    only ['Player']
  end
  delete do
    except ['Team', 'Ball']
  end
end
```

### Visible block

You can use these 3 bindings to decide whereas the action should be visible or not:

- `bindings[:controller]` is current controller instance
- `bindings[:abstract_model]` is checked abstract model (except root actions)
- `bindings[:object]` is checked instance object (member actions only)

For instance, if you want to allow editing of games, but only if they haven't yet started:

```ruby
config.actions do
  edit do
    visible do
      object = bindings[:object]
      case object
      when Game then !object.started? # only allow editing games if they haven't started
      when Player then true           # allow editing of Players any time
      else false                      # don't allow editing anything else
      end
    end
  end
end
```

Have a look at [Show in App implementation](../lib/rails_admin/config/actions/show_in_app.rb) for a better idea of how you can take advantage of this.

Important: at some point of the application lifecycle, bindings can be nil:

- when RailsAdmin creates the route
- when RailsAdmin defines the action in its controller

These bindings are available in all options.
