### Orderable / Sortable Has Many without Through

There is an existing [[example|Has-many-:through-association]] for order able `has_many :through` associations. However, for simpler cases it can be done directly without `:through`. I have tested the below with Mongoid adapter and using [[|Simple Has Many Field|Simple-Has-Many-Field-Type-(Association)]] and it worked well. Please feel free to clean up or optimize. 

```ruby
  def column_ids=(ids)
    unless (ids = ids.map(&:to_s)) == (current_ids = columns.map(&:_id).map(&:to_s))
      (current_ids - ids).each { |id| columns.select{|b|b.id.to_s == id}.first.remove }
      ids.each_with_index.map do |id, index|
        if current_ids.include?(id)
          (column = columns.select{|b|b.id.to_s == id}.first).position = (index+1)
          column
        else
          c = Column.find(id)
          c.dataset = self
          c.position = (index+1)
        end
      end
    end
  end
```