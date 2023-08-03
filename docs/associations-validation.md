# Associations validation

`:validates_presence_of` works for `belongs_to`, `has_one` and `has_many` associations in Rails3, so you can safely have:

```ruby
belongs_to :draft
validates :draft, :presence => true # you will need one associated object
# validates :draft_id, :presence => true would also work, but is not recommended (validation of foreign key).

has_one :team
validates :team, :presence => true # you will need one associated object

has_many :comments
validates :comments, :presence => true # you will need at least one associated object
```

RailsAdmin will look on both `:draft` and `:draft_id` for validation when checking for `:required?` and for displaying errors messages.

Polymorphic `belongs_to` will work as well, the same way.

`validates_associated` is a different thing: it validates the opposite object(s), and nil (no associated object) is valid for `belongs_to` associations.
