To use the CKEditor with Upload function, add [Rails-CKEditor](https://github.com/galetahub/ckeditor) to your Gemfile (`gem 'ckeditor'`) and follow [Rails-CKEditor](https://github.com/galetahub/ckeditor) installation instructions.

You can configure more options of CKEditor "config.js" file following the [Api Documentation](http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html) .

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      # For RailsAdmin >= 0.5.0
      field :description, :ck_editor
      # For RailsAdmin < 0.5.0
      # field :description do
      #   ckeditor true
      # end
    end
  end
end
```

## Configuration

CKEditor accepts [various options](https://ckeditor.com/docs/ckeditor4/latest/api/CKEDITOR_config.html), you can configure them in following way:

```ruby
field :description, :ck_editor do
  config_js ActionController::Base.helpers.asset_path('your_ckeditor_config.js')
end
```

## Misc

When using Rails-CKEditor, remember to configure ckeditor in asset precompile:

```
Rails.application.config.assets.precompile += ['ckeditor/*']
```

[More here](https://github.com/railsadminteam/rails_admin/blob/master/lib/rails_admin/config/fields/types/ck_editor.rb)
