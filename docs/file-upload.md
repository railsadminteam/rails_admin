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

## On a Mongoid embedded document

An upload field stores its file in a callback of the model it belongs to, and Mongoid runs the callbacks of an embedded document only when the association says so:

```ruby
embeds_many :photos, cascade_callbacks: true
accepts_nested_attributes_for :photos
```

Without it the parent saves without complaint and the embedded document is written with no file behind it, while an update leaves the uploader's placeholder behind as the stored filename.

[More here](https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/file_upload.rb)
