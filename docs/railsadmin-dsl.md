**Model configuration location**

Each model configuration can alternatively be in two places:

* Inside the RailsAdmin initializer

`config/initializers/rails_admin.rb`
```ruby
RailsAdmin.config do |config|
  ...
  config.model 'ModelName' do 
    ...
  end
end
```

* In the model definition file:

_app/models/model_name.rb_
```ruby
class ModelName < ActiveRecord::Base
  ...
  rails_admin do 
    ...
  end
end
```

This is your choice to make:
* The initializer is loaded once at startup (modifications will show up when restarting the application) and may slow down your application startup, but all RailsAdmin configuration will stay in one place.
* Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.

**The object_label_method method**

The model configuration option `object_label_method` configures
the title display of a single database record, i.e. an instance of a model.

By default it tries to call "name" or "title" methods on the record in question. If the object responds to neither,
then the label will be constructed from the model's classname appended with its
database identifier. You can add label methods (or replace the default [:name, :title]) with:

```ruby
RailsAdmin.config {|c| c.label_methods << :description}
```

This `object_label_method` value is used in a number of places in RailsAdmin--for instance for the
output of belongs to associations in the listing views of related models, for
the option labels of the relational fields' input widgets in the edit views of
related models and for part of the audit information stored in the history
records--so keep in mind that this configuration option has widespread
effects.

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    object_label_method do
      :custom_label_method
    end
  end

  def custom_label_method
    "Team #{self.name}"
  end
end
```

*Difference between `label` and `object_label`*

`label` and `object_label` are both model configuration options. `label` is used
whenever Rails Admin refers to a model class, while `object_label` is used whenever
Rails Admin refers to an instance of a model class (representing a single database record).



**Fields - Visibility and ordering**

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
          current_user.roles.include?(:accounting) # metacode
        end
      end
    end
  end
end
```

Note that above example's authorization conditional is not runnable code, just
an imaginary example. You need to provide RailsAdmin with your own
authorization scheme for which you can find a guide at the end of this file.

**Fields - Label**

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

**Fields - Output formatting**

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

### Create and update views

**Form rendering**

RailsAdmin renders these views with is own form builder: `RailsAdmin::FormBuilder`
You can inherit from it to customize form output.

**Field groupings**

By default RailsAdmin groups fields in the edit views (create and update views)
by including all database columns and associations to the `:default` group.

The configuration accessors are `edit`, `create` and `update`. First one is a
batch accessor which configures both create and update views. For consistency,
these examples only include the batch accessor `edit`, but if you need differing
create and update views just replace `edit` with `create` or `update`. If you need
to configure the form when it is displayed as a modal, replace `edit` with `modal`.

**Field groupings - visibility**

Field groups can be hidden:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        hide
      end
    end
  end
end
```

This would hide the default group which is accessed by the symbol :default.
The hide method is just a shortcut for the actual `visible`
option which was mentioned in the beginning of the navigation section.

**Field groupings - labels**

Field groups can be renamed:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        label "Team information"
      end
    end
  end
end
```

This would render "Team information" instead of "Basic info" as the groups label.

**Field groupings - help**

Field groups can have a set of instructions which is displayed under the label:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        label "Team information"
        help "Please fill all informations related to your team..."
      end
    end
  end
end
```

This content is mostly useful when the admin doing the data entry is not familiar with the system or as a way to display inline documentation.


**Field groupings - syntax**

As in the list view, the edit views' configuration blocks can directly
contain field configurations, but in edit views those configurations can
also be nested within group configurations. Below examples result an
equal configuration:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        label "Default group"
      end
      field :name do
        label "Title"
        group :default
      end
    end
  end
end

RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        label "Default group"
        field :name do
          label "Title"
        end
      end
    end
  end
end
```

**Important note on label - I18n**

Use association name as translation key for label for association fields.
If you have :user_id field with a user association, use :user as the attribute

In fact the first examples `group :default` configuration is unnecessary
as the default group has already initialized all fields and
associations for itself.

**Field groupings - toggles**

By default, all field groups (other than :default) will have a toggle and start off active.  To change the default and have a field group start off with the toggle inactive, use 'active false'

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :advanced do
        active false
      end
    end
  end
end
```


**Fields**

Just like in the list view, all fields are visible by default. If you specifically
declare fields, only defined fields will be visible and they will be presented
in the order defined. Thus both examples would render a form with
only one group (labeled "Default group") that would contain only one
element (labeled "Title").

If you would like to configure fields in the default group without changing the other
fields already included in the default group, you can use the `configure` block like this:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      configure :name do
        hide
      end
    end
  end
end
```

This would hide the name field on the team edit page, but it would not affect
any of the other field defaults.

In the list view label is the text displayed in the field's column header, but
in the edit views label literally means the html label element associated with
field's input element.

Naturally edit views' fields also have the visible option along with
hide and show accessors as the list view has.

**Fields - rendering**

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

One can also completely override the rendering logic:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      field :name do
        def render
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

**Fields - overriding field type**

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

**Fields - Creating a custom field type**

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

**Fields - Creating a custom field factory**

Type guessing can be overridden by registering a custom field "factory", but
for now you need to study `lib/rails_admin/config/fields/factories/*` for
examples if you want to use that mechanism.

**Fields - Overriding field help texts**

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
        email: '%{help}. Popular webmail addresses not allowed'
```

%{help} will be replaced by the rails_admin default generated help message.

### Configuring fields ###

**Fields - exclude some fields**

By default *all* fields found on your model will be added to list/edit/export views,  if no field is found for the section and model.

But after you specify your *first* field with `field(field_name, field_type = found_column_type, &conf_block)` or `include_field` or `fields`, this behaviour will be canceled.

*Only* the specified fields will be added.
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

Be careful, if you exclude fields before anything is added, this will instead add all other fields, which might not be what you expect (especially since fields ordering will be frozen). See https://github.com/sferik/rails_admin/issues/859 for an example.

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

**Fields - include some fields**

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

Note that some fields are hidden by default (source fields for belongs_to associations) and that you can display them to the list view by
manually setting them to visible:

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

### Examples
[[Select and Multi-Select using Enumeration field type approach|https://github.com/sferik/rails_admin/wiki/Enumeration]]