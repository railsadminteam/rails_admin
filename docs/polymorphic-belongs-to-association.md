Synopsys:

```ruby
class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :inverse_of => :comments
  attr_accessible :commentable_id, :commentable_type
end

# for info
class Team < ActiveRecord::Base
  has_many :comments, :as => :commentable, :inverse_of => :commentable
end


RailsAdmin.config |config| do
  config.model Comment do
    configure :commentable do
      # configuration here
      # https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/polymorphic_association.rb
    end
  end
end
```
