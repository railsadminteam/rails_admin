# `belongs_to` association

```ruby
class Player < ActiveRecord::Base
  belongs_to :team, :inverse_of => :players   # dropdown select: belongs_to association
  # or for nested fields:
  accepts_nested_attributes_for :team, :allow_destroy => true
end

# for info
class Team < ActiveRecord::Base
  has_many :players, :inverse_of => :team
end
```

[More here](../lib/rails_admin/config/fields/types/belongs_to_association.rb)
