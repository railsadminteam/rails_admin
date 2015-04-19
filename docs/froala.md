This assume you want to use the FREE version of Froala Editor (which shows their badge in the editor). For more information, please see: http://www.froala.com/

### How to use:

1. Add Froala's assets gem. **Note: ** For now we'll need to use codynguyen's fork, where the assets are precompiled (which is needed for rails_admin).

  ```
    gem "wysiwyg-rails", github: "codynguyen/wysiwyg-rails"
  ```

2. Enabling froala editor for your field is easy

  ```
  edit do
    field :content, :froala
  end

  # Optionally providing froala options (see https://editor.froala.com/options)
  edit do
    field :content, :froala do
      config_options {
        inlineMode: false,
        paragraphy: false
      }
    end
  end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/froala.rb]] and [[here|https://github.com/sferik/rails_admin/blob/master/app/assets/javascripts/rails_admin/ra.widgets.coffee]]