Section used for the index view.

It inherits its configuration from the `base` section.

**Number of items per page**

You can configure the default number of rows rendered per page:

```ruby
RailsAdmin.config do |config|
  config.default_items_per_page = 50
end
```

**Number of items per page per model**

You can also configure it per model:

```ruby
RailsAdmin.config do |config|
  config.model Team do
    list do
      items_per_page 100
    end
  end
end
```

**Default sorting**

By default, rows sorted by the field `id` in reverse order

You can change default behavior with use two options: `sort_by` and `sort_reverse`

```ruby
RailsAdmin.config do |config|
  config.model Player do
    list do
      sort_by :name
      sort_reverse false
    end
  end
end
```


[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/sections/list.rb]]