You can include/exclude models totally. They won't appear in RailsAdmin at all.

**Blacklist Approach**

```ruby
RailsAdmin.config do |config|
  config.excluded_models << "ClassName"
end
```

**Whitelist Approach**

By default, RailsAdmin automatically discovers all the models in the system and adds them to its list of models to
be accessible through RailsAdmin. The `excluded_models` configuration above permits the blacklisting of individual model classes.

If you prefer a whitelist approach, then you can use the `included_models` configuration option instead:

```ruby
RailsAdmin.config do |config|
  config.included_models = ["Class1", "Class2", "Class3"]
end
```
Only the models explicitly listed will be put under RailsAdmin access, and the auto-discovery of models is skipped.

The blacklist is effective on top of that, still, so that if you also have:

```ruby
RailsAdmin.config do |config|
  config.excluded_models = ["Class1"]
end
```

then only `Class2` and `Class3` would be made available to RailsAdmin.

The whitelist approach may be useful if RailsAdmin is used only for a part of the application and you want to make
sure that new models are not automatically added to RailsAdmin, e.g. because of security concerns.


Once done with the choice of model, you can customize the way they appear in the navigation.

**Setting the model's label**

```ruby
RailsAdmin.config do |config|
  config.model Team do
    label "List of teams"
  end
end
```

This label will be used anywhere the model name is shown, e.g. on the navigation tabs,
Dashboard page, list pages, etc.

