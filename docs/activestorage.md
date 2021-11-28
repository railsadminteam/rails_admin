# ActiveStorage

Install and configure according to [the official instruction](https://github.com/rails/rails/tree/master/activestorage#installation), first.

Your model should look like this:

## Simple upload

```ruby
class Article < ActiveRecord::Base
  has_one_attached :asset
end
```

You can specify the field as an 'active_storage' type if not detected:

```ruby
field :asset, :active_storage
```

### Deleting an attachment

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
  delete_method :remove_asset
end
```

### show correct file name of attachment

```ruby
field :asset, :active_storage do
  delete_method :remove_asset
  pretty_value do
    if value
      path = Rails.application.routes.url_helpers.rails_blob_path(value, only_path: true)
      bindings[:view].content_tag(:a, value.filename, href: path)
    end
  end
end
```

## Multiple uploads

Support for multiple uploads works the same way:

```ruby
class Article < ActiveRecord::Base
  has_many_attached :assets
end
```

### Deleting Multiple attachments

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

<!-- `assets.where(id: remove_assets).find_each(&:purge)` does not work well when we add images -->

```ruby
field :assets, :multiple_active_storage do
  delete_method :remove_assets
end
```

### show correct file name for Multiple attachments

```ruby
#TODO

```

### show thumbnails on show and edit views

Showing thumbnails may require additional setup.

For images, Rails 6 recommend installing the [`image_processing`](https://github.com/janko/image_processing) gem:

```ruby
# add to your gemfile
gem 'image_processing', '~> 1.2'
```
