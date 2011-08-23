Pre-requisite: Enums are well-documented in the readme file so please read up on that first.

This recipe uses the baseball teams example app under the dummy_app directory:

Consider the following model for Teams:

```ruby
class Team < ActiveRecord::Base
  ....
  def color_enum
    ['white', 'black', 'red', 'green', 'blue']
  end
   ...
end
```

Rails Admin initializes the drop-down for enums to include a blank row, please see the following file:

```ruby
app/views/rails_admin/main/_form_enumeration.html.haml
2:  = form.select field.method_name, field.enum, {:include_blank => true}, field.html_attributes.merge({ :class => "enum" })
```
So if you are adding a new record using Rails Admin, it will show the blank row by default.  If you want to pre-select a default value however, e.g., in the Team model above, suppose you want it to default to the 'red' color instead, then here is how do achieve it:

```ruby
class Team < ActiveRecord::Base
  ....
  after_initialize :init
  
  def init
     self.color ||= 'red'
  end

  def color_enum
    ['white', 'black', 'red', 'green', 'blue']
  end
   ...
end
```

The "after_initialize" hook (or callback) triggers after a model record is instantiated.  It will set the color value to 'red' for a new record and will leave it to its current value for an existing record (in the edit view).

