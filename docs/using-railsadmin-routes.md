### Link to RailsAdmin resources from your application :

```ruby
rails_admin.new_path('module~class_names')
rails_admin.list_path('module~class_names')
rails_admin.export_path('module~class_names')

rails_admin.show_path('module~class_names', Module::ClassName.first.id)
rails_admin.edit_path('module~class_names', Module::ClassName.first.id)
rails_admin.delete_path('module~class_names', Module::ClassName.first.id)
```

### Link to your application from RailsAdmin (usually a config block)

```ruby
main_app.article_path(my_article)
```