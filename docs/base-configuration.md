The configuration will be executed at startup time, once. (dev & production)

Rake tasks that load environment don't execute RailsAdmin initializer's block, for performance and DB migration status compatibility.

You can force it (true or false):

`SKIP_RAILS_ADMIN_INITIALIZER=false rake mytask`

**Set the application name:**

```ruby
RailsAdmin.config do |config|
  config.main_app_name = ["Cool app", "BackOffice"]
end
# or somethig more dynamic
RailsAdmin.config do |config|
  config.main_app_name = Proc.new { |controller| [ "Cool app", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }
end
```

**Authentication**

You can customize authentication by providing a custom block for `RailsAdmin.authenticate_with`.
To disable authentication, pass an empty block:

```ruby
RailsAdmin.config do |config|
  config.authenticate_with {}
end
```
