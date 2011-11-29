### Optional CKEditor integration

To use the CKEditor with Upload function, add [Rails-CKEditor](https://github.com/galetahub/ckeditor) to your Gemfile (`gem 'ckeditor'`) and follow [Rails-CKEditor](https://github.com/galetahub/ckeditor) installation instructions.

You can configure more options of CKEditor "config.js" file following the [Api Documentation](http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html) .

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      field :description, :text do
        ckeditor true
      end
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/text.rb]]