RailsAdmin always adds a blank entry in drop-downs, so if you are adding a new record using Rails Admin, it will be blank by default. To pre-select a default value however, e.g.please do it in your model definition, at initialization time:

```ruby
class Team < ActiveRecord::Base
  ....
  after_initialize do
    if new_record?
      self.color ||= 'red' # be VERY careful with ||= and False values
    end
  end

  def color_enum
    ['white', 'black', 'red', 'green', 'blue']
  end
   ...
end
```

The "after_initialize" hook (or callback) triggers after a model record is instantiated.  It will set the color value to 'red' for a new record and will leave it to its current value for an existing record (in the edit view).
