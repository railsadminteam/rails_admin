Synopsis:
Rails 3
```ruby
class Player < ActiveRecord::Base
  belongs_to :team, :inverse_of => :players

  # if you want a dropdown select: (natural choice for a belongs_to association)

    attr_accessible :team_id

  # or for nested fields: 

    attr_accessible :team_attributes
    accepts_nested_attributes_for :team, :allow_destroy => true

  rails_admin do
    configure :team do
      # configuration here
    end
  end
end

# for info
class Team < ActiveRecord::Base
  has_many :players, :inverse_of => :team
end
```

Rails 4 has no `attr_accessible`
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

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/belongs_to_association.rb]]