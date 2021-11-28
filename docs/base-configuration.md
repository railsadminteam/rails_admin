# Base configuration

RailsAdmin provides its out of the box administrative interface by inspecting your application's
models and following some Rails conventions. For a more tailored experience, it also provides a
configuration DSL which allows you to customize many aspects of the interface.

**Set the application name:**

```ruby
RailsAdmin.config do |config|
  config.main_app_name = ["Cool app", "BackOffice"]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| [ "Cool app", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }
end
```

**Locale**

If your default_locale is different from :en, set your default locale at the beginning of the file:

```ruby
require 'i18n'
I18n.default_locale = :de
```

**Authentication integration (Devise, Sorcery, Manual)**

[Authentication](authentication.md)

**Authorization (Cancan)**

[Authorization](authorization.md)

**ActiveModel's :attr_accessible :attr_protected**

Default is :default (default for ActiveModel)

```ruby
config.attr_accessible_role { :default }
```

`_current_user` is accessible in the block if you need to make it user specific:

```ruby
config.attr_accessible_role { _current_user.role.to_sym }
```

**Instance labels**

```ruby
config.label_methods << :description # Default is [:name, :title]
```

**Browser validations**

```ruby
config.browser_validations = false # Default is true
```

**Next**

Then you can start adding [actions](actions.md), configuring [models](models.md), [sections](base.md) and [fields](fields.md).
