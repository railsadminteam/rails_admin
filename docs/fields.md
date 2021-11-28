## Visibility and ordering

By default all fields are visible, but they are not presented in any particular
order. If you specifically declare fields, only defined fields will be visible
and they will be presented in the order defined:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name
      field :created_at
    end
  end
end
```

This would show only "name" and "created at" columns in the list view.

If you would like to configure fields in the default group without changing the other
fields already included in the default group, you can use the `configure` block like this:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      configure :name do
        hide
      end
    end
  end
end
```

This would hide the name field on the team list page, but it would not affect
any of the other field defaults.

### Virtual Fields

It is possible to configure Rails Admin to display "virtual" fields--fields that are not database attributes on the model. Just define them as methods on your model, then configure a field of the same name.

In your model add a method with any name, like:

```ruby
class Address < ApplicationRecord
  belongs_to :state
  belongs_to :city

  # Virtual field method
  def full_address
    [self.street, self.number, self.city.name, self.state.name].compact.join(', ')
  end
end
```

And

```ruby
RailsAdmin.config do |config|
  config.model Address do
    list do
      # virtual field
      configure :full_address do
        # any configuration
      end
      fields :full_address, :street, :number #, ...
    end
  end
end
```

### Controlling by logic

If you need to hide fields based on some logic on runtime (for instance
authorization to view field) you can pass a block for the `visible` option
(including its `hide` and `show` accessors):

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name
      field :created_at
      field :revenue do
        visible do
          bindings[:view]._current_user.roles.include?(:accounting)
        end
      end
    end
  end
end
```

Note that above example's authorization conditional is not runnable code, just
an imaginary example. You need to provide RailsAdmin with your own
authorization scheme for which you can find a guide at the end of this file.

### Exclusion

By default _all_ fields found on your model will be added to list/edit/export views, if no field is found for the section and model.

But after you specify your _first_ field with `field(field_name, field_type = found_column_type, &conf_block)` or `include_field` or `fields`, this behaviour will be canceled.

_Only_ the specified fields will be added.
If you don't want that very behavior, use `configure` instead of `field` (same signature).
That way, that field won't be added to the section, just configured.

Once in `add specified fields` mode, you can exclude some specific fields with exclude_fields & exclude_fields_if:

Example:

```ruby
RailsAdmin.config do |config|
  config.model 'League' do
    list do
      exclude_fields_if do
        type == :datetime
      end

      exclude_fields :id, :name
    end
  end
end
```

Be careful, if you exclude fields before anything is added, this will instead add all other fields, which might not be what you expect (especially since fields ordering will be frozen). See https://github.com/railsadminteam/rails_admin/issues/859 for an example.

You can use include_all_fields to add all default fields:

Example:

```ruby
RailsAdmin.config do |config|
  config.model 'League' do
    list do
      field :name do
        # snipped specific configuration for name attribute
      end
      include_all_fields # all other default fields will be added after, conveniently
      exclude_fields :created_at # but you still can remove fields
    end
  end
end
```

### Inclusion

It is also possible to add fields by group and configure them by group:

Example:

```ruby
RailsAdmin.config do |config|
  config.model 'League' do
    list do
      # all selected fields will be added, but you can't configure them.
      # If you need to select them by type, see *fields_of_type*
      include_fields_if do
        name =~ /displayed/
      end

      include_fields :name, :title                # simply adding fields by their names (order will be maintained)
      fields :created_at, :updated_at do          # adding and configuring
        label do
          "#{label} (timestamp)"
        end
      end
    end
  end
end
```

Note that some fields are hidden by default (source fields for belongs_to associations) and that you can display them to the list view by manually setting them to visible:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :league_id do
        visible true
      end
    end
  end
end
```

## Label

The header of a list view column can be changed with the familiar label method:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name do
        label "Title"
      end
      field :created_at do
        label "Created on"
      end
    end
  end
end
```

As in the previous example this would show only columns for fields "name" and
"created at" and their headers would have been renamed to "Title" and
"Created on".

Also applies to an edit form, which will change the html label element associated with
field's input element.

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name do
        label "Title"
      end
    end
  end
end
```

## Output formatting

The field's output can be modified:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name do
        formatted_value do # used in form views
          value.to_s.upcase
        end

        pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
          value.titleize
        end

        export_value do
          value.camelize # used in exports, where no html/data is allowed
        end
      end
      field :created_at
    end
  end
end
```

This would render all the teams' names uppercased.

The field declarations also have access to a bindings hash which contains the
current record instance in key :object and the view instance in key :view.
Via :object we can access other columns' values and via :view we can access our
application's view helpers:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name do
        formatted_value do
          bindings[:view].tag(:img, { :src => bindings[:object].logo_url }) << value
        end
      end
      field :created_at
    end
  end
end
```

This would output the name column prepended with team's logo using the `tag`
view helper. This example uses `value` method to access the name field's value,
but that could be written more verbosely as `bindings[:object].name`.

### Render a link (a tag, href)

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    show do
      field :name do
        read_only true
        pretty_value do
          v = bindings[:view]
          team = bindings[:object]
          url = team.ticket_page
          # value will point to bindings[:object].name
          v.link_to(value, url, target: '_blank', rel: 'noopener noreferrer')
        end
      end
    end
  end
end
```

Fields of different date types (date, datetime, time, timestamp) have two extra
options to set the time formatting:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :name
      field :created_at do
        date_format :short
      end
      field :updated_at do
        strftime_format "%Y-%m-%d"
      end
    end
  end
end
```

This would render all the teams' "created at" dates in the short format of your
application's locale and "updated at" dates in format YYYY-MM-DD. If both
options are defined for a single field, `strftime_format` has precedence over
`date_format` option. For more information about localizing Rails see
[Rails Internationalization API](http://edgeguides.rubyonrails.org/i18n.html#adding-date-time-formats)
and [Rails I18n repository](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale).

## Form rendering

The edit view's fields are rendered using partials. Each field type has its own
partial per default, but that can be overridden:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name do
        partial "my_awesome_partial"
      end
    end
  end
end
```

The partial should be placed in your applications template folder, such as
`app/views/rails_admin/main/_my_awesome_partial.html.erb`.

The object is available from the partial with `form.object`.

One can also completely override the rendering logic:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name do
        render do
          bindings[:view].render :partial => partial.to_s, :locals => {:field => self, :form => bindings[:form]}
        end
      end
    end
  end
end
```

You can flag a field as read only, and if necessary fine-tune the output with pretty_value:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :published do
        read_only true
        pretty_value do
          bindings[:object].published? ? "Yes, it's live!" : "No, in the loop..."
        end
      end
    end
  end
end
```

## Help

Every field is accompanied by a hint/text help based on model's validations.
Everything can be overridden with `help`:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name
      field :email do
        help 'Required - popular webmail addresses not allowed'
      end
    end
  end
end
```

Since v0.6 you can also override your fields help text based on rails i18n functionality, using your locale files:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name
      field :email
    end
  end
end
```

```yml
en:
  admin:
    help:
      team:
        email: "%{help}. Popular webmail addresses not allowed"
```

%{help} will be replaced by the rails_admin default generated help message.

## Overriding field type

If you'd like to override the type of the field that gets instantiated, the
field method provides second parameter which is field type as a symbol. For
instance, if we have a column that's a text column in the database, but we'd
like to have it as a string type we could accomplish that like this:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :description, :string do
         # configuration here
      end
    end
  end
end
```

If no configuration needs to take place the configuration block could have been
left out:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :description, :string
    end
  end
end
```

A word of warning, if you make field declarations for the same field a number
of times with a type defining second argument in place, the type definition
will ditch the old field configuration and load a new field instance in place.

## Creating a custom field type

If you have a reusable field you can define a custom class extending
`RailsAdmin::Config::Fields::Base` and register it for RailsAdmin:

```ruby
RailsAdmin::Config::Fields::Types::register(:my_awesome_type, MyAwesomeFieldClass)
```

Then you can use your custom class in a field:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name, :my_awesome_type do
        # configuration here
      end
    end
  end
end
```

### Existing custom field type (color picker field)

Did you know Rails Admin comes with useful custom color picker field type? You can use it for editing but also for listing.

```ruby
rails_admin do
    field :color, :color
end
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name, :color
    end
    list do
      field :name, :color
    end
    # Or simply as follow if you want to use it everywhere
    field :name, :color
  end
end
```

## Creating a custom field factory

Type guessing can be overridden by registering a custom field "factory", but
for now you need to study `lib/rails_admin/config/fields/factories/*` for
examples if you want to use that mechanism.

## Making all fields readonly by default

Borrowing from [Configuring models all at once](models.md#configuring-models-all-at-once, you can use the following to make fields read-only by default:

```rb
RailsAdmin.config do |config|
  ActiveRecord::Base.descendants.each do |imodel|
    config.model "#{imodel.name}" do
      base do
        fields do
          read_only true

          # If you want rules about inclusion or exclusion of fields to only apply at the model level,
          # you should include the following two lines. (This code should be in the initializer in order
          # to run first and not clobber the `order` and `defined` attributes from your model config.)
          #
          # See also:
          #  - https://github.com/railsadminteam/rails_admin/blob/v1.1.1/lib/rails_admin/config/has_fields.rb#L93-L94
          #  - https://github.com/railsadminteam/rails_admin/blob/v1.1.1/lib/rails_admin/config/lazy_model.rb#L26-L47
          #
          self.defined = false
          self.order = nil
        end
      end
    end
  end
end
```

Note: this requires rails_admin >= 1.0.0.rc (depends on [#2670](https://github.com/railsadminteam/rails_admin/pull/2670)).
