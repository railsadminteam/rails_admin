RailsAdmin uses a sass release of bootstrap for CSS, and bootstrap/jquery-ui for JS.

### For custom theming (application scoped), simply override these files in your app:

```
app/assets/stylesheets/rails_admin/custom/mixins.css.scss
app/assets/stylesheets/rails_admin/custom/theming.css.scss
app/assets/stylesheets/rails_admin/custom/variables.css.scss
app/assets/javascripts/rails_admin/custom/ui.js
```

### For reusable and sharable themes, add these files to your plugin:

```
vendor/assets/stylesheets/rails_admin/themes/__THEME_NAME__/mixins.css.scss
vendor/assets/stylesheets/rails_admin/themes/__THEME_NAME__/theming.css.scss
vendor/assets/stylesheets/rails_admin/themes/__THEME_NAME__/variables.css.scss
vendor/assets/javascripts/rails_admin/themes/__THEME_NAME__/ui.js
```

All 4 files must be present (even if empty).

### CSS

Put all the real theming in `theming.css.scss`. It can be regular CSS, LESS or [[SCSS|http://sass-lang.com/]]

Note that if you choose to use SCSS, you can:

* modify all the mixins provided by rails_admin and bootstrap and add others for you to use in `mixins.css.scss`.
* modify all the variables provided by rails_admin and bootstrap and add others for you to use in `variables.css.scss`.
* In `theming.css.scss`:
  * use all defined mixins and variables.
  * include any other .scss file with `@import rails_admin/themes/__THEME_NAME__/my_scss_file` and organize your the rest of your theme the way you want.

### JS

Use anything you want that the asset pipeline supports: regular JS, includes, Coffee, ..

### Use a theme

Inside `config/application.rb`
```ruby
ENV['RAILS_ADMIN_THEME'] = '__THEME_NAME__'
```

### Create a theme

Replace `__THEME_NAME__` with the real name of your theme in the following snippet and paste it in your shell:

```bash
rails plugin new rails_admin___THEME_NAME__
cd rails_admin___THEME_NAME__/
mkdir -p vendor/assets/stylesheets/rails_admin/themes/__THEME_NAME__/
mkdir -p vendor/assets/javascripts/rails_admin/themes/__THEME_NAME__/
cd vendor/assets/stylesheets/rails_admin/themes/__THEME_NAME__/
touch mixins.css.scss theming.css.scss variables.css.scss
cd ../../../../javascripts/rails_admin/themes/__THEME_NAME__/
touch ui.js
```

TODO: refactor to a generator.
See the `Existing themes` section for an example.

### Resources:

* [[Boostrap|http://twitter.github.com/bootstrap/]]
* [[Bootstrap Sass|https://github.com/thomas-mcdonald/bootstrap-sass]]

### Existing themes:

* [[Example theme|https://github.com/bbenezech/rails_admin_example_theme]]: technical stub you can use for bootstrapping.
* Designer of feel like one? Add your own.