Unlike [Orderable Sortable Has Many without Through
](orderable-sortable-has-many-without-through.md) with [Has And Belongs To Many](http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#method-i-has_and_belongs_to_many) you don't care that you destroy/recreate the objects every time you want to change the order (as they only hold `record1_id` and `record2_id`) in a table row.

The problem is that when you change order of records Rails don't see this as a change (as the ID's are the same) that's why you need to explicitly destroy and recreate them.

```ruby
class Category < ApplicationRecord
  has_and_belongs_to_many :projects
  validates_presence_of :title

  def project_ids=(ids)
    super([])
    super(ids)
  end 

  rails_admin do
    configure :projects do
      orderable true
    end 
  end 
end

class Project < ApplicationRecord
  has_and_belongs_to_many :categories
end
```

migration:

```
class ProjectsCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_projects do |t|
      t.integer :project_id
      t.integer :category_id
    end
  end
end
```