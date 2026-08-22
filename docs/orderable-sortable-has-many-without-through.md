### Orderable / Sortable Has Many without Through

There is an existing [example](has-many-through-association.md) for order able `has_many :through` associations. However, for simpler cases it can be done directly without `:through`. I have tested the below with `Mongoig` adapter and using [Simple Has Many Field](simple-has-many-field-type-association.md) and it worked well. Please feel free to clean up or optimize. 

Example below is for a Library model that has many Books association.

```ruby
  def books_ids=(ids)
    unless (ids = ids.map(&:to_s)) == (current_ids = self.books.map(&:_id).map(&:to_s))
      (current_ids - ids).each { |id| self.books.select{|b|b.id.to_s == id}.first.remove }
      ids.each_with_index.map do |id, index|
        if current_ids.include?(id)
          (book = self.books.select{|b|b.id.to_s == id}.first).position = (index+1)
        else
          b = Book.find(id)
          b.library = self
          b.position = (index+1)
        end
      end
    end
  end
```
