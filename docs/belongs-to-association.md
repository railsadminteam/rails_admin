Synopsys:

```ruby
class Player < ActiveRecord::Base
  belongs_to :team, :inverse_of => :players
  attr_accessible :team_id
end

# for info
class Team < ActiveRecord::Base
  has_many :players, :inverse_of => :team
end


RailsAdmin.config |config| do
  config.model Player do
    configure :team do
      # configuration here
    end
  end
end
```
