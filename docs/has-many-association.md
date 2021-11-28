# `has_many` association

Synopsys:

```ruby
class Team < ActiveRecord::Base
  has_many :players, :dependent => :destroy, :inverse_of => :team

  # for a nested form: (natural choice for 1-n associations)
  accepts_nested_attributes_for :players, :allow_destroy => true

  # uncomment if you don't use strong parameters
  # attr_accessible :players_attributes, :allow_destroy => true

  # for a multiselect widget:
  # uncomment if you don't use strong parameters
  # attr_accessible :player_ids

  rails_admin do
    configure :players do
      # configuration here
    end
  end
end

# for info
class Player < ActiveRecord::Base
  belongs_to :team, :inverse_of => :players
end
```

[More here](../lib/rails_admin/config/fields/types/has_many_association.rb)
