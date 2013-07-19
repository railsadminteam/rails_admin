To use the CKEditor with Upload function, add [Rails-CKEditor](https://github.com/galetahub/ckeditor) to your Gemfile (`gem 'ckeditor'`) and follow [Rails-CKEditor](https://github.com/galetahub/ckeditor) installation instructions.

You can configure more options of CKEditor "config.js" file following the [Api Documentation](http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html) .

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      field :description, :ck_editor
    end
  end
end
```

Note that CKeditor won't appear in AJAX-loaded modals, due to CKeditor limitations with AJAX loading/unloading (basically it's crap).

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/ck_editor.rb]]