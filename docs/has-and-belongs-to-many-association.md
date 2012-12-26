Synopsys:

```ruby
class Team < ActiveRecord::Base
  has_and_belongs_to_many :fans

  # for a multiselect widget: (natural choice for n-n associations)

    attr_accessible :fan_ids

  # for a nested form: 
   
    accepts_nested_attributes_for :fans, :allow_destroy => true
    attr_accessible :fans_attributes

  rails_admin do
    configure :fans do
      inverse_of :teams
      # configuration here
    end
  end
end

# for info
class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/has_and_belongs_to_many_association.rb]]