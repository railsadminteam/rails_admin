# Carrierwave

Once added to your Gemfile, and after `bundle install` has been run, Carrierwave is ready to be used with rails admin. No further configuration is required to integrate it.

Your model should look like this:

```ruby
class Article < ActiveRecord::Base
  mount_uploader :asset, AssetUploader
end
```

You can specify the field as a 'carrierwave' type if not detected:

```ruby
field :asset, :carrierwave
```

Now a file upload field will be added to your model's form.

## Polymorphic association

If you have an Asset model class as polymorphic and you want a thumbnail in you Article model.

Create the association:

```ruby
class Article < ActiveRecord::Base
  has_one :post_thumbnail, :as => :assetable, :class_name => Asset
end
```

In rails_admin.rb initializer indicate :post_thumbnail should be a file tag.

```ruby
config.model Asset do
  edit do
    field :asset, :carrierwave
  end
end
config.model Article do
  nested do
    field :post_thumbnail
  end
end
```

## Multiple upload

RailsAdmin also work with CarrierWave's native multiple upload feature, but it has a little quirkiness and needs some work depending on your usage.

Simple setup goes like:

```ruby
class Article < ActiveRecord::Base
  mount_uploaders :assets, AssetUploader
end
```

```ruby
field :assets, :multiple_carrierwave
```

### Want to delete attachments

CarrierWave decides whether the attachments to be deleted or not by looking `remove_#{name}` attribute. But when activated, it removes all attachments, so RailsAdmin decided not to use it.

Instead, you need to implement alternative way in your model like this:

```ruby
class Article < ActiveRecord::Base
  mount_uploaders :assets, CarrierwaveUploader
  attr_accessor :delete_assets
  after_validation do
    uploaders = assets.delete_if do |uploader|
      if Array(delete_assets).include?(uploader.file.filename)
        uploader.remove!
        true
      end
    end
    write_attribute(:assets, uploaders.map { |uploader| uploader.file.filename })
  end
end
```

### Want to preserve existing attachments when uploading more

By default, CarrierWave's multiple upload feature discards existing ones when new files are uploaded. Here's a workaround:

```ruby
class Article < ActiveRecord::Base
  mount_uploaders :assets, CarrierwaveUploader
  def assets=(files)
    appended = files.map do |file|
      uploader = _mounter(:assets).blank_uploader
      uploader.cache! file
      uploader
    end
    super(assets + appended)
  end
end
```

[More here](../lib/rails_admin/config/fields/types/carrierwave.rb)
