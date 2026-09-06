### Link to RailsAdmin resources from your application :

```ruby
rails_admin.dashboard_path
...

rails_admin.index_path('module~class_name')
rails_admin.new_path('module~class_name')
...

rails_admin.show_path(model_name: 'blog~post', id: post.id)
rails_admin.edit_path(model_name: 'blog~post', id: post.id)
...
```

Namespaced models must use a '~' between modules and class name.

### Link to your application from RailsAdmin (usually from a config block)

```ruby
main_app.article_path(my_article)
# from a config block:
bindings[:view].main_app.article_path(my_article)
```

### Link to RailsAdmin from RailsAdmin

```ruby
# from a config block:
bindings[:view].link_to('new record', bindings[:view].rails_admin.new_path('module~class_name'))

# Eg.
field :custom_action do
  formatted_value do
    bindings[:view].link_to('new record', bindings[:view].rails_admin.new_path('module~class_name', key: 'value'))
  end
end
```
