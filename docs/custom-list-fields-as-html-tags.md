You can customise list view fields as HTML tags, to replace their defaults with links or images. This saves having to create an entire partial just for a single field.

```ruby
field :name do
  pretty_value do
    path = bindings[:view].show_path(model_name: 'User', id: bindings[:object].id)
    bindings[:view].tag(:a, href: path) << bindings[:object].name
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