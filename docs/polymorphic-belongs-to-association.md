Synopsis:

```ruby
class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :inverse_of => :comments

  rails_admin do
    configure :commentable do
      # configuration here
    end
  end
end

# for info
class Team < ActiveRecord::Base
  has_many :comments, :as => :commentable, :inverse_of => :commentable
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/polymorphic_association.rb]]