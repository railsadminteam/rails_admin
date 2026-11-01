> **Deprecated.** The `:ck_editor` field type will be removed in RailsAdmin 5.0. CKEditor 4 reached
> end-of-life, and no freely licensed release of it is free of known vulnerabilities: the fixes live
> in the commercially licensed CKEditor 4 LTS line. RailsAdmin therefore names no CKEditor to load,
> and the field does nothing until you point it at one.

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

## Pointing the field at a CKEditor

Nothing loads until `base_location` names a directory holding `ckeditor.js` and `config.js`, or
`location` names the script directly. Which build that is - a licensed CKEditor 4 LTS release, one
you serve yourself, one from a CDN - is the application's decision:

```ruby
field :description, :ck_editor do
  base_location 'https://your-cdn.example.com/ckeditor/4.25.1/'
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
