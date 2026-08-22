You can add your custom search method instead of using the default search. This will help you to add any type of association even if you don't want to show them on the listing page.

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