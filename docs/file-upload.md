# File upload

File upload is a 'virtual' field type not meant to be used directly, but through vendor implementations ([Paperclip](paperclip.md)/[Dragonfly](dragonfly.md)/[Carrierwave](carrierwave.md)/[ActiveStorage](activestorage.md))

Those implementation share common characteristics.

If defaults don't fit, fine-tune with:

```ruby
field :asset do
  # set a method available to your asset (defaults to :thumb, :thumbnail or '100x100>' for Dragonfly)
  thumb_method :large

  # for delete checkbox in forms
  delete_method :asset_delete     # don't forget to whitelist if you use :attr_accessible

  # in case of a validation failure, to retain asset in the form (not available for Paperclip)
  cache_method :asset_cache       # don't forget to whitelist if you use :attr_accessible
end
```

[More here](../lib/rails_admin/config/fields/types/file_upload.rb)
