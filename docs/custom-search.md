You can add your custom search method instead of using the default search. This will help you to add any type of association even if you don't want to show them on the listing page.

# Searching a serialized field

A serialized field is searched as the string the store keeps it as. On ActiveRecord that is the text column the serialization is written to, markup and all, and on Mongoid a regular expression is compared against every element of an `Array` field.

A Mongoid `Hash` field is a subdocument, which no regular expression matches. Name the key to search it:

```ruby
config.model Item do
  list do
    field :data do
      searchable 'items.data.key' # <collection>.<field path>
    end
  end
end
```

Anything more than that is what `search_by` below is for.

# Example 1

```ruby
config.model Player do
  list do
    search_by :my_search
  end
end

class Player < ApplicationRecord
  scope :my_search, -> (keyword) { where(name: keyword) }
end
```

# Example 2 using `pg_search`

```ruby
config.model Player do
  list do
    search_by :my_search
  end
end

class Player < ApplicationRecord
  pg_search_scope :my_search,
    :against => [:id],
    :associated_against => {
      translations: :name
    },
    using: {
      tsearch: {any_word: true,},
      trigram: {threshold: 0.1}
    }
end
```
