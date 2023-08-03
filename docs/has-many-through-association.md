# `has_many` `:through` association

Synopsis:

```ruby

class Grid < ActiveRecord::Base

  has_many :block_grid_associations, :dependent => :delete_all, :autosave => true, :include => :block
  has_many :blocks, :through => :block_grid_associations

  # for a multiselect widget: (natural choice for n-n associations)

    attr_accessible :block_ids
    # if you need ordered blocks inside each grid (assuming a position column in block_grid_associations table)
    def block_ids=(ids)
      unless (ids = ids.map(&:to_i).select{|i|i>0}) == (current_ids = block_grid_associations.map(&:block_id))
        (current_ids - ids).each { |id| block_grid_associations.select{|b|b.block_id == id}.first.mark_for_destruction }
        self.blocks = ids.each_with_index.map do |id, index|
          if current_ids.include?(id)
            (block_association = block_grid_associations.select{|b|b.block_id == id}.first).position = (index+1)
            block_association
          else
            block_grid_associations.build({:block_id => id, :position => (index+1)})
          end
        end.map(&:block)
      end
    end

  # for a nested form: (no reordering)

    accepts_nested_attributes_for :blocks, :allow_destroy => true
    attr_accessible :blocks_attributes

  rails_admin do
    configure :block_grid_associations do
      visible(false)
    end

    configure :blocks do
      orderable(true) # only for multiselect widget currently. Will add the possibility to order blocks
      # configuration here
    end
  end
end

# for info

class Block < ActiveRecord::Base
  has_many :block_grid_associations, :dependent => :delete_all
  has_many :grids, :through => :block_grid_associations
end

class BlockGridAssociation < ActiveRecord::Base
  belongs_to :block
  belongs_to :grid
  default_scope order(:position) # if you need ordered blocks
end
```

Note: `has_many :through` associations are not considered any differently from vanilla `has_many` association. In particular, no special help is provided to edit join table attributes; you can edit indifferently the join-table or the target table.

### Alternative

The code above didn't work for me. There were some join models created with the position attribute set, and then the self.blocks assignment created new join models with a nil position. I don't know if the code is equivalent to the former, but it works for me and it's a lot simpler.

```ruby
def block_ids=(ids)
  unless (ids = ids.map(&:to_i).select { |i| i>0 }) == (current_ids = block_grid_associations.map(&:block_id))
    (current_ids - ids).each { |id| block_grid_associations.select{|b|b.block_id == id}.first.mark_for_destruction }
    ids.each_with_index do |id, index|
      if current_ids.include? (id)
        block_grid_associations.select { |b| b.block_id == id }.first.position = (index+1)
      else
        block_grid_associations.build({:block_id => id, :position => (index+1)})
      end
    end
  end
end
```

### Cleaner Alternative

The code above didn't destroy the outdated associations for me. I've refactored the code to fix the bugs and make it easier to read here.

```ruby
 #This is used to order blocks from the grids
  def block_ids=(ids)
    ids = ids.reject{|i| i == "" || i == nil}.map{|i| i.to_i}
    current_ids = block_grid_associations.map(&:block_id)
    if current_ids != ids
      destroy_outdated_block_associations(current_ids, ids)
      ids.each_with_index do |id, index|
        if current_ids.include? (id)
          update_block_association_position(id, index+1)
        else
          grid_block_associations.build({:block_id => id, :position => (index+1)})
        end
      end
    end
  end

  private

  def destroy_outdated_block_associations(current_ids, ids)
    (current_ids - ids).each { |id| block_grid_associations.select{|b| b.block_id == id}.first.destroy }
  end

  def update_block_association_position(id, position)
    block_grid_associations.select { |b| b.block_id == id }.first.update_attributes(position: position)
  end

```

### Another Alternative

I wasn't able to use any of the examples above with a validate_presence_of validation. So I came up with my own version. Take note that the position column must absolutely have a default value in the db.

```ruby
 #This is used to order blocks from the grids
  def block_ids=(ids)
    super(ids)
    ids = ids.reject(&:blank?).map(&:to_i) # Flush empty id
    ids.each_with_index do |id, index|
      block = block_grid_associations.detect { |b| b.block_id == id }
      block.update_column :position, index + 1
    end
  end

```

[More here (has_many)](../lib/rails_admin/config/fields/types/has_many_association.rb)
