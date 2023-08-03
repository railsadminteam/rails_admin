# CKEditor

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

Although ckeditor is loaded in modal windows (e.g. twb), by default changes are not saved by submitting the modal. This is because the underlying textarea gets not updated before the ajax post request is issued. To prevent this you can use the following code:

```coffeescript
$(document).ready ->
  $(document).on 'mousedown', '.save-action', (e) -> # triggers also when submitting form with enter
    for instance of CKEDITOR.instances
      editor = CKEDITOR.instances[instance]
      if editor.checkDirty()
        editor.updateElement();
    return true;
```

Add this code to assets/javascripts/rails_admin/custom/ckeditor_ajax.js.coffee and create a file assets/javascripts/rails_admin/custom/ui.js that loads this coffee file into asset pipeline:

```
//= require rails_admin/custom/ckeditor_ajax
```

Reminder: It's necessary to configure ckeditor in asset precompile:

```
Rails.application.config.assets.precompile += ['ckeditor/*']
```

[More here](../lib/rails_admin/config/fields/types/ck_editor.rb)
