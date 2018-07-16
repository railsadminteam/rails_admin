Install and configure according to [the official instruction](https://github.com/rails/rails/tree/master/activestorage#installation), first.

Your model should look like this:

```ruby
class Article < ActiveRecord::Base
  has_one_attached :asset
end
```

You can specify the field as a 'active_storage' type if not detected:

```ruby
field :asset, :active_storage
```

## Deleting attachment

You need to define a delete method if you want to delete attachment:

```ruby
class Article < ActiveRecord::Base
  has_one_attached :asset
  attr_accessor :remove_asset
  after_save { asset.purge if remove_asset == '1' }
end
```

The method name is `remove_#{name}` by default, but you can configure it using `delete_method` option:

```ruby
field :asset, :active_storage do
  delete_method :delete_asset
end
```

## Multiple upload

Support for multiple upload works the same way:

```ruby
class Article < ActiveRecord::Base
  has_many_attached :assets
  # for deletion
  attr_accessor :remove_assets
  after_save do
    Array(remove_assets).each { |id| assets.find_by_id(id).try(:purge) }
  end
end
```

```ruby
field :assets, :multiple_active_storage
```
