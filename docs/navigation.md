# Navigation

You can include/exclude models totally. They won't appear in RailsAdmin at all.

By default, RailsAdmin automatically discovers all the models in the system and adds them to its list of models to
be accessible through RailsAdmin.

**Blacklist Approach**

The `excluded_models` configuration above permits the blacklisting of individual model classes.

```ruby
config.excluded_models << "ClassName"
```

**Whitelist Approach**

If you prefer a whitelist approach, then you can use the `included_models` configuration option instead:

```ruby
config.included_models = ["Class1", "Class2", "Class3"]
```

Only the models explicitly listed will be put under RailsAdmin access, and the auto-discovery of models is skipped.

The blacklist is effective on top of that, still, so that if you also have:

```ruby
config.excluded_models = ["Class1"]
```

then only `Class2` and `Class3` would be made available to RailsAdmin.

The whitelist approach may be useful if RailsAdmin is used only for a part of the application and you want to make
sure that new models are not automatically added to RailsAdmin, e.g. because of security concerns.

Once done with the choice of model, you can customize the way they appear in the navigation.

**Static links**

Static links can be appended to the main navigation:

```ruby
config.navigation_static_links = {
  'Google' => 'http://www.google.com'
}
```

They are displayed in a separate group with default name 'Links', but you can change it:

```ruby
config.navigation_static_label = "My Links"
```

**Setting the model's label**

RailsAdmin will use ActiveModel I18n API by default, so this shouldn't be needed. Still, you can configure label, and its plural, if needed:

```ruby
config.model 'Box' do
  label "Beautiful box"
  label_plural "Beautiful boxen"
end
```

But again, this is **way better** to do it in `config/locale/en.yml`:

```yml
en:
  ...
  activerecord:
    models:
      box:
        one: Beautiful box
        other: Beautiful boxen
    attributes:
      box:
        color: "Shade of grey"
        ...
```

This label will be used anywhere the model name is shown, e.g. on the navigation tabs,
Dashboard page, list pages, etc.

**Setting the navigation icon**

You can set the navigation icon from the bootstrap theme this way :

```ruby
config.model 'User' do
  navigation_icon 'icon-user'
end
```

**Hiding a model**

You can hide a model from the top navigation by marking its `visible` option
as false:

By passing the value as an argument:

```ruby
config.model 'Team' do
  visible false
end
```

Or by passing a block that will be lazy evaluated each time the option is read:

```ruby
config.model 'Team' do
  visible do
    # controller bindings is available here. Example:
    bindings[:controller].current_user.role == :admin
  end
end
```

These two examples also work as a generic example of how most of the
configuration options function within RailsAdmin. You can pass a value as an
argument `option_name value`, or you can pass in a block which will be
evaluated each time the option is read. Notable is that boolean options' reader
accessors will be appended with ? whereas the writers will not be. That is, if
you want to get the Team model's visibility, you use
`RailsAdmin.config(Team).visible?`.

**Treeview List**

```ruby
# Given there are the following models: League, Team and Division

config.model 'Team' do
  parent League
end

config.model 'Division' do
  parent League
end
```

Obtained navigation:

    Dashboard
    ...
    League
      Division
      Team
    ...

**Create a navigation_label in navigation**

You probably want to change the name of the navigation_label.
This can be easily achieved with the 'navigation_label' method of the parent model.

Added to previous example:

```ruby
config.model 'League' do
  navigation_label 'League related'
end
```

Obtained navigation:

    Dashboard
    ...
    League related  # (non-clickable)
      League
      Division
      Team
    ...

**Change models order in navigation**

By default, they are ordered by alphabetical order. If you need to override this, specify
a weight attribute. Default is 0. Lower values will bubble items to the top, higher values
will move them to the bottom. Items with same weight will still be ordered by alphabetical order.
The mechanism is fully compatible with navigation labels. Items will be ordered within their own
menu subset (but the parent item will always be first inside this submenu).

Example:

```ruby
config.model 'League' do
  navigation_label 'League related'
  weight -1
end
```

The 'League related' navigation label will move to the topmost position.

**Method for instances label**

Set the method name for instances' label. Will default to the first `Config.label_methods` (see [base configuration](base-configuration.md)) that instances respond to. You can set it explicitly:

```ruby
config.model 'Team' do
  object_label_method :custom_name_method
end
```
