# Dragonfly

If a `asset_uid` column is found, it will be hidden (along with the optional `asset_name` column) and a `field :asset, :dragonfly` will be created.

Due to the 'fire and forget' nature of Dragonfly and the obfuscated uid, RailsAdmin cannot always infer if asset is an image or not (show thumbnails or links?).

It will try to read `asset_name` to see the extension for a smart guess. If absent, it will suppose it is an image.

See the #image option in [File Upload](file-upload.md) if you need to override this behavior.

```ruby
class Article < ActiveRecord::Base
  dragonfly_accessor :asset
  # don't forget those if you use :attr_accessible (delete method and form caching method are provided by Dragonfly and used by RailsAdmin)
  attr_accessible :asset, :remove_asset, :retained_asset
end
```

[More here](../lib/rails_admin/config/fields/types/dragonfly.rb)
