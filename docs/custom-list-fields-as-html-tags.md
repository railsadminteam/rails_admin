You can customise list view fields as HTML tags, to replace their defaults with links or images. This saves having to create an entire partial just for a single field.

An example of a link tag showing User.name and linking to the user model within rails admin:

```ruby
field :name do
  pretty_value do
    path = bindings[:view].show_path(model_name: 'User', id: bindings[:object].id)
    bindings[:view].content_tag(:a, bindings[:object].name, href: path)
  end
end
```

An example of an image field:

```ruby
field :image do
  pretty_value do
    bindings[:view].tag(:img, { :src => bindings[:object].image.url })
  end
end
```
