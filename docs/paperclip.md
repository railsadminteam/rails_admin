# Paperclip

Install and read https://github.com/thoughtbot/paperclip and https://github.com/thoughtbot/paperclip/wiki/Thumbnail-Generation first.

```bash
$ rails generate paperclip product asset
```

Automatically detected.

Considering a `has_attached_file :asset` declaration, all :asset_file_name, :asset_content_type.. columns will be hidden. A file upload field will be created and accessible for customization in the DSL: `field :asset, :paperclip`.

One thing you may need is a delete method in your model.
Paperclip does not include it, you'll need to add it manually.
RailsAdmin will detect it and add a checkbox.

```ruby
class Product < ActiveRecord::Base
  has_attached_file :asset,
    :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" }
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/
  # add a delete_<asset_name> method:
  attr_accessor :delete_asset
  before_validation { self.asset.clear if self.delete_asset == '1' }
end
```

If you use a `attr_accessible` strategy, don't forget to add `delete_asset` to the whitelist.

[More here](../lib/rails_admin/config/fields/types/paperclip.rb)
