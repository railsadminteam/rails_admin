This assume you want to use the FREE version of Froala WYSIWYG HTML Editor (which shows their badge in the editor). For more information, please see: http://www.froala.com/wysiwyg-editor

### How to use:

RailsAdmin loads Froala from a CDN, so no extra gem is needed. Enabling the froala editor for your field is easy:

```
edit do
  field :content, :froala
end

# Optionally providing froala options (see https://froala.com/wysiwyg-editor/docs/options/)
edit do
  field :content, :froala do
    config_options do
      {
        inlineMode: false,
        paragraphy: false
      }
    end
  end
end
```

[More here](https://github.com/railsadminteam/rails_admin/blob/master/lib/rails_admin/config/fields/types/froala.rb) and [here](https://github.com/railsadminteam/rails_admin/blob/master/src/rails_admin/widgets.js)

### Using Plugins

RailsAdmin loads the Froala core from a CDN, and each field decides which build that is:

```ruby
edit do
  field :content, :froala do
    js_location '/froala-with-plugins.js'
    css_location '/froala-with-plugins.css'
  end
end
```

[Froala plugins] are separate files which have to be evaluated after the core, so point `js_location` and `css_location` at a build of your own that already contains the plugins you want, rather than trying to load them alongside. Under `config.asset_source = :external` you can equally import Froala and its plugins into the `rails_admin.js` / `rails_admin.scss` entrypoints the installer generates.

The `app/assets/{javascripts,stylesheets}/rails_admin/custom/*` files this used to rely on were removed in 4.0.

[Froala plugins]: https://www.froala.com/wysiwyg-editor/docs/plugins
