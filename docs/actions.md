## Default

Actions used to be static and hard-coded. A community request was that they could be added/removed/customized.

This is now possible.

By default, to keep existing installation safe, all actions are added as they used to be.

Default is equivalent to:

```ruby
# config/initilizers/rails_admin.rb
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
    show                           # mandatory
    edit
    delete
    history_show
    show_in_app
  end
end
```

## Action visibility

### Authorization

Authorization is done automatically before any link is displayed, any page accessed, etc.
Check [[Cancan]] for the list of key used by RailsAdmin default actions.

You can change the authorization key with:

```ruby
config.actions do
  dashboard do
    authorization_key :customized
  end
  ...
end
```

### Visible block

You can use these 3 bindings to decide whereas the action should be visible or not:

* `bindings[:controller]` is current controller instance
* `bindings[:abstract_model]` is checked abstract model
* `bindings[:object]` is checked instance object

Have a look at [[Show in App implementation|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/show_in_app.rb]] for a better idea of how you can take advantage of this.

Important: at some point of the application lifecycle, bindings can be nil:

* when RailsAdmin creates the route
* when RailsAdmin defines the action in its controller

**Visible then need to return `true`.**

## Action wording for title, menu, bredcrumb and links

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

See [[rails_admin.en.yml|https://github.com/sferik/rails_admin/blob/master/config/locales/rails_admin.en.yml]] to get an idea.

Actions can provide specific option configuration, check their respective wiki page.