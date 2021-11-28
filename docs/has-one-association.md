# `has_one` association

Synopsis:

```ruby
class Player < ActiveRecord::Base
  has_one :draft, :dependent => :destroy, :inverse_of => :player

  # for nested fields: (natural choice for a has_one association)

    attr_accessible :draft_attributes
    accepts_nested_attributes_for :draft, :allow_destroy => true

  # or if you want a dropdown select:

    attr_accessible :draft_id

    # Since ActiveRecord does not create setters/getters for has_one associations (why is beyond me), diy:
    def draft_id
      self.draft.try :id
    end
    def draft_id=(id)
      self.draft = Draft.find_by_id(id)
    end

  rails_admin do
    configure :draft do
      # configuration here
    end
  end
end

# for info
class Draft < ActiveRecord::Base
  belongs_to :player, :inverse_of => :draft
end
```

[More here](../lib/rails_admin/config/fields/types/has_one_association.rb)
