Automatically detected.

One thing you may need is to add a delete method in your model.
`Paperclip` does not include it, you'll need to add it manually.
`RailsAdmin` will detect it and add a checkbox.

`article.rb`

```ruby
class Article < ActiveRecord::Base
  has_attached_file :asset
  # add a delete_<asset_name> method: 
  attr_accessor :delete_asset
  before_validation { self.asset.clear if self.delete_asset == '1' }
end
```