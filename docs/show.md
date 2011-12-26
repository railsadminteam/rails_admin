Section used for the show view.

It inherits its configuration from the `base` section.

You can display empty fields in show view with:

```ruby
RailsAdmin.config do |config|
  config.compact_show_view = false
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/sections/show.rb]]