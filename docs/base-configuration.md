RailsAdmin provides its out of the box administrative interface by inspecting your application's
models and following some Rails conventions. For a more tailored experience, it also provides a
configuration DSL which allows you to customize many aspects of the interface.

A customized configuration guide is generated at installation in `config/initializers/rails_admin.rb`

This initializer in `config/initializer/rails_admin.rb` is executed at startup time, once.

Rake tasks that load environment don't execute RailsAdmin initializer's block, for performance and DB migration status compatibility.

You can force it if needed:

`SKIP_RAILS_ADMIN_INITIALIZER=false rake mytask`

**Set the application name:**

```ruby
RailsAdmin.config do |config|
  config.main_app_name = ["Cool app", "BackOffice"]
  # or somethig more dynamic
  config.main_app_name = Proc.new { |controller| [ "Cool app", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }
end
```

**Locale**

If your default_local is different from :en, set your default locale at the beginning of the file:

```ruby
require 'i18n'
I18n.default_locale = :de
```

**current_user method**

The current_user is usually inferred from your Devise settings and added to your initializer file automatically.

If needed, it can be customized as such:

```ruby
config.current_user_method { current_admin }
```

 **Authentication (before_filter)**

This is run inside the controller instance so you can setup any authentication you need to.

By default, the authentication will run via warden if available, and will run on the default user scope.

If you use devise, this will authenticate the same as `authenticate_user!`

Example Devise admin:

```ruby
config.authenticate_with do
  authenticate_admin!
end
```

Example Custom Warden:

```ruby
config.authenticate_with do
  warden.authenticate! :scope => :paranoid
end
```

To disable authentication, pass an empty block:

```ruby
RailsAdmin.config do |config|
  config.authenticate_with {}
end
```

**Authorization (before_filter)**

Use cancan https://github.com/ryanb/cancan for authorization:

```ruby
config.authorize_with :cancan
```

Or use simple custom authorization rule:

```ruby
config.authorize_with do
  redirect_to main_app.root_path unless warden.user.is_admin?
end
```

**ActiveModel's :attr_acessible :attr_protected**

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

**Next**

Then you can start adding [[actions|Actions]], configuring [[models|Navigation]], [[sections|Base]] and [[fields|Railsadmin-DSL]].