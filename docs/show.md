# Show

Section used for the show view.

It inherits its configuration from the `base` section.

To configure which fields are shown in the "Show" view of a model, use the `show` method in the config block:

```ruby
RailsAdmin.config do |config|
  config.model 'BlogPage' do
    show do
      field :title
      field :author_name
    end
  end
end
```

#

You can display empty fields in show view with:

```ruby
RailsAdmin.config do |config|
  config.compact_show_view = false
end
```

[More here](../lib/rails_admin/config/sections/show.rb)
