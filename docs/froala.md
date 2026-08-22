This assume you want to use the FREE version of Froala Editor (which shows their badge in the editor). For more information, please see: http://www.froala.com/wysiwyg-editor

### How to use:

1. Add Froala's assets gem.

    *Note:* This functionality is currently available in the master branches of both `rails_admin` and `froala/wysiwyg-rails`, but neither gem has released a version with these features. For now, we'll need to use specific revisions of these gems from GitHub:

    ```
    gem "rails_admin", github: "sferik/rails_admin", ref: "43f368a" # pending release of > 0.6.7
    gem "wysiwyg-rails", github: "froala/wysiwyg-rails", ref: "8daf0c3" # pending release of > 1.2.6
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

[More here](https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/froala.rb) and [here](https://github.com/sferik/rails_admin/blob/master/app/assets/javascripts/rails_admin/ra.widgets.coffee)

### Using Plugins

Some additional configuration is necessary in order to use [Froala plugins]:

1. In `app/assets/javascripts/rails_admin/custom/ui.js`:

    ```
    //= require froala_editor.min
    // Include the plugins you want:
    //= require plugins/block_styles.min
    //= require plugins/colors.min
    //= require plugins/media_manager.min
    //= require plugins/tables.min
    //= require plugins/video.min
    //= require plugins/font_family.min
    //= require plugins/font_size.min
    //= require plugins/file_upload.min
    //= require plugins/lists.min
    //= require plugins/char_counter.min
    //= require plugins/fullscreen.min
    //= require plugins/urls.min
    //= require plugins/inline_styles.min
    ```

2. In `app/assets/stylesheets/rails_admin/custom/theming.scss`:

    ```
    @import "froala_editor.min";
    @import "froala_style.min";
    @import "font-awesome";
    ```

3. If you're deploying to Heroku, you may need to add these files to Rails' asset precompilation list.

    In `config/initializers/assets.rb`:

    ```
    Rails.application.config.assets.precompile += %w(rails_admin/custom/theming.css rails_admin/custom/ui.js)
    ```

[Froala plugins]: https://www.froala.com/wysiwyg-editor/docs/plugins