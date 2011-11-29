### Ordered associations

For has\_many/has\_and\_belongs\_to\_many/has\_many :through

Orderable can be enabled on filtering multiselect fields (has_many, has_many :through & has_and_belongs_to_many associations), allowing selected options to be moved up/down.

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

If you set the :inverse_of option on your relations, RailsAdmin will automatically populate the inverse relationship
in the modal creation window. (link next to belongs\_to and has\_many widgets)

### Readonly

:readonly options are automatically inferred on associations fields and won't be editable in forms.