# `has_and_belongs_to_many` association

Synopsys:

For a multiselect widget: (natural choice for n-n associations)

```ruby
class Team < ActiveRecord::Base
  has_and_belongs_to_many :fans

  attr_accessible :fan_ids
end
```

Or for a nested form:

```ruby
class Team < ActiveRecord::Base
  has_and_belongs_to_many :fans

  accepts_nested_attributes_for :fans, :allow_destroy => true
  attr_accessible :fans_attributes

  rails_admin do
    configure :fans do
      inverse_of :teams
      # configuration here
    end
  end
end
```

The other side of the association is as usual:

```ruby
# for info
class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams
end
```

This will work for regular many-to-many relationships and self-referential many-to-manys.

For Rails 4+ don't need to use `attr_accessible`

[More here](../lib/rails_admin/config/fields/types/has_and_belongs_to_many_association.rb)
