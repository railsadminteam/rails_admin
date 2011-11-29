### Ordered associations

For `has_many/has_and_belongs_to_many/has_many :through`

Orderable can be enabled on filtering multiselect fields, allowing selected options to be moved up/down.

RailsAdmin will handle ordering in and out of the form.

```ruby
RailsAdmin.config do |config|
  config.model Player do
    edit do
      field :fans do
        orderable true
      end
    end
  end
end
```

You'll need to handle ordering in your model with a position column for example. See [[here|Has-many-%3Athrough-association]] for a comprehensive ActiveRecord example with a `has_many :through` association.

### Multiselect

You can edit related objects in filtering-multiselect by double-clicking on any visible item in the widget.

### Avoiding edit recursions on inverse associations

If you set the `:inverse_of` option on your relations, RailsAdmin will automatically populate the inverse relationship
in the modal creation window. (link next to :belongs\_to and :has\_many multiselect widgets)

It will also hide the inverse relation on nested forms. As a good practice, you should always set `:inverse_of` options. It will help ActiveRecord performances and RailsAdmin will take advantage of its definition.

### Readonly

:readonly options are automatically inferred on associations fields and won't be editable in forms.