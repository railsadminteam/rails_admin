# Groups

By default RailsAdmin groups fields in the edit views (create and update views)
by including all database columns and associations to the `:default` group.

The configuration accessors are `edit`, `create` and `update`. First one is a
batch accessor which configures both create and update views. For consistency,
these examples only include the batch accessor `edit`, but if you need differing
create and update views just replace `edit` with `create` or `update`. If you need
to configure the form when it is displayed as a modal, replace `edit` with `modal`.
Attention: If you lose some fields after using `groupings`, add `include_all_fields` to your configuration.

## Visibility

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

## Labels

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

## Help

Field groups can have a set of instructions which is displayed under the label:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    edit do
      group :default do
        label "Team information"
        help "Please fill all information related to your team..."
      end
    end
  end
end
```

This content is mostly useful when the admin doing the data entry is not familiar with the system or as a way to display inline documentation.

## Syntax

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

### Important note on label - I18n

Use association name as translation key for label for association fields.
If you have :user_id field with a user association, use :user as the attribute

In fact the first examples `group :default` configuration is unnecessary
as the default group has already initialized all fields and
associations for itself.

## Toggles

By default, all field groups (other than :default) will have a toggle and start off active. To change the default and have a field group start off with the toggle inactive, use 'active false'

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
