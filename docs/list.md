# List

Section used for the index view.

It inherits its configuration from the `base` section.

### Width of the list table

```ruby
RailsAdmin.config do |config|
  config.total_columns_width = 1000
end
```

Also see how to [show all columns on one page in a horizontally-scrolling table](horizontally-scrolling-table-with-frozen-columns-in-list-view.md).

### Width of individual columns

By default, columns have a `max-width` of 120px, and no `min-width`. While there does not appear to be fine-grained controls for max-/min-width, you can specify a fixed width in pixels for individual columns:

```ruby
RailsAdmin.config do |config|
  config.model 'Player' do
    list do
      field :created_at do # (1)
        column_width 300
      end
    end
  end
end
```

### Number of items per page

You can configure the default number of rows rendered per page:

```ruby
RailsAdmin.config do |config|
  config.default_items_per_page = 50
end
```

### Number of items per page per model

You can also configure it per model:

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      items_per_page 100
    end
  end
end
```

### Default sorting

By default, rows are sorted by the field `id` in reverse order

You can change default behavior with use two options: `sort_by` and `sort_reverse`

```ruby
RailsAdmin.config do |config|
  config.model 'Player' do
    list do
      sort_by :name
      field :name do
        sort_reverse false
      end
    end
  end
end
```

### Filters

Default visible filters. Must be a list of fields name.

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      filters [:name, :manager]
      # Manually enable/disable per field
      field :name do
        filterable true
      end
      field :manager do
        filterable true
      end
    end
  end
end
```

### Fields sorting

- You can make a column non-sortable by setting the sortable option to false (1)
- You can change the column that the field will actually sort on (2)

`belongs_to` associations:

- will be sorted on their label if label is not virtual (:name, :title, etc.)
- otherwise on the foreign_key (:team_id)
- you can also specify a column on the targetted table (see example) (3)

```ruby
RailsAdmin.config do |config|
  config.model 'Player' do
    list do
      field :created_at do # (1)
        sortable false
      end
      field :name do # (2)
       sortable :last_name # imagine there is a :last_name column and that :name is virtual
      end
      field :team do # (3)
        # Will order by players playing with the best teams,
        # rather than the team name (by default),
        # or the team id (dull but default if object_label_method is not a column name)

        sortable :win_percentage

        # if you need to specify the join association name:
        # (See #526 and http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#label-Table+Aliasing)
        sortable {Team => :win_percentage}
        # or
        sortable {:teams => :win_percentage}
        # or
        sortable "teams.win_percentage"
       end
    end
  end
end
```

By default, dates and serial ids are reversed when first-sorted ('desc' instead of 'asc' in SQL).
If you want to reverse (or cancel it) the default sort order (first column click or the default sort column):

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      field :id do
        sort_reverse false   # will sort id increasing ('asc') first ones first (default is last ones first)
      end
      field :created_at do
        sort_reverse false   # will sort dates increasing ('asc') first ones first (default is last ones first)
      end
      field :name do
        sort_reverse true    # will sort name decreasing ('dec') z->a (default is a->z)
      end
    end
  end
end
```

### Fields searching

- You can make a column non-searchable by setting the searchable option to false (1)
- You can change the column that the field will actually search on (2)
- You can specify a list of column that will be searched over (3)

Belongs_to associations:

- will be searched on their foreign_key (:team_id)
- or on their label if label is not virtual (:name, :title, etc.)
- you can also specify columns on the targeted table or the source table (see example) (4)
- will not be searched unless `queryable` is set to `true`

```ruby
RailsAdmin.config do |config|
  config.model 'Player' do
    list do
      field :created_at do # (1)
        searchable false
      end

      field :name do # (2)
        searchable :last_name
      end
      # OR
      field :name do # (3)
        searchable [:first_name, :last_name]
      end

      field :team do # (4)
        queryable true
        searchable [:name, :id]
        # eq. to [Team => :name, Team => :id]
        # or even [:name, Player => :team_id] will search on teams.name and players.team_id
        # if you need to specify the join association name:
        # (See #526 and http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html => table_aliasing)
        searchable [{:teams => :name}, {:teams => :id}]
        # or
        searchable ["teams.name", "teams.id"]
      end
    end
  end
end
```

For associations with multiple filterable columns configured, a record with _any_ filterable column matching the filter string will be returned. There is not currently a way to split out association columns into separate filters. (E.g. if you filter players by "Team: 5", then any players on team #5 _plus_ any players whose team name contains a "5" will be returned.)

Searchable definitions will be used for searches and filters.
You can independently deactivate querying (search) or filtering for each field with:

```ruby
field :team do
  searchable [:name, :color]
  queryable true # default except for associations
  filterable false
end
```

### Scopes

This allows to display a configurable scoped list view.

First will be the default, nil means no scope (also it is possible to disable non-scoped index)

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      scopes [:not_cart, :cart, nil]
    end
  end
end
```

This can also be used for achieving `unscoped` list view(i.e. ignoring `default_scope`):

```ruby
RailsAdmin.config do |config|
  config.model 'Player' do
    list do
      scopes [:unscoped]
    end
  end
end
```

### Limited pagination

It allows to avoid `count(*)` query which take a lot of resources on big tables.
Pagination includes only: `next`/`prev` buttons.
Default value is `false`.

```ruby
RailsAdmin.config do |config|
  config.model 'Team' do
    list do
      limited_pagination true
    end
  end
end
```

[More here](../lib/rails_admin/config/sections/list.rb)

[List view table styling](list-view-table-styling.md)
