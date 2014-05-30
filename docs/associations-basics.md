### Select/Multiselect widget

#### Ordered associations

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

You'll need to handle ordering in your model with a position column for example. See [[here|Has-many-:through-association]] for a comprehensive ActiveRecord example with a `has_many :through` association.

#### Important
You must specify attr_accessible for the singular-form _ids setter method of your associated model. (This setter method comes automatically with ActiveRecord when you create a has_many association). In the example above, you would specify this at the top of your model. 
```
attr_accessible :fan_ids
```
If you fail to do this, the multiselect widget will simply not appear on your page. 

#### Editing records

You can edit related objects by double-clicking on any visible item in the widget.

#### Limit/filter associated records

See [[associations scoping]] for more informations on how to limit and filter proposed associated records.

#### Inverse_of: Avoiding edit association spaghetti issues

If you set the `:inverse_of` option on your relations, RailsAdmin will automatically populate the inverse relationship
in the modal creation window. (link next to :belongs\_to and :has\_many multiselect widgets)

It will also hide the inverse relation on nested forms. As a good practice, you should always set `:inverse_of` options to all your associations, even if these are useless to ActiveRecord (in combination with :through and :as). RailsAdmin will take advantage of them. But it will bomb 'Unknown key: inverse_of' on HABTMs, you'll need to set them manually:

Simply set it directly into your configuration:

```ruby
config.model Team do
  field :categories do
    inverse_of :teams
  end
end
```

#### Readonly

`:readonly` options are automatically inferred from associations and won't be editable in forms.

#### Nested form

If you have accepts_nested_attributes set up in your model but don't want the association to be a nested form in your model:

```ruby
config.model Team do
  field :players do
    nested_form false
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/association.rb]]