Once added to your Gemfile, and after ```bundle install``` has been run, Carrierwave is ready to be used with rails admin.  No further configuration is required to integrate it.

Your model should look like this:

```ruby
class Article < ActiveRecord::Base
  mount_uploader :asset, AssetUploader
  # don't forget those if you use :attr_accessible (delete method and form caching method are provided by Carrierwave and used by RailsAdmin)
  attr_accessor :asset, :asset_cache, :remove_asset
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

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/carrierwave.rb]]