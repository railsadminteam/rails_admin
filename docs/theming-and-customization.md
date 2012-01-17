RailsAdmin uses a sass release of bootstrap for CSS, and bootstrap/jquery-ui for JS.

### For custom theming (application scoped), simply override these files in your app:

```
app/assets/stylesheets/rails_admin/custom/mixins.css.scss
app/assets/stylesheets/rails_admin/custom/theming.css.scss
app/assets/stylesheets/rails_admin/custom/variables.css.scss
app/assets/javascripts/rails_admin/custom/ui.js
```

### To create a distributable theme

```
rails plugin new rails_admin_<__THEME_NAME__> -m https://raw.github.com/gist/1523639 --skip-gemfile --skip-bundle -T -O --full
```

Then add to your application `Gemfile` (before RailsAdmin):
```ruby
gem 'rails_admin_<__THEME_NAME__>', :path => '../rails_admin_<__THEME_NAME__>'
```

Inside your rails_admin application `config/application.rb`, just after `Bundler.require`:
```ruby
ENV['RAILS_ADMIN_THEME'] = '<__THEME_NAME__>'
```

This will allow for convenient live development testing.

Please follow the convention: `rails_admin_` prefix for all RailsAdmin related gems.

Once done, upload it on Github with a valid gemspec (change authors, email and project descriptions) to share your work.

### CSS

Put all the real theming in `theming.css.scss`. It can be regular CSS, LESS or [[SCSS|http://sass-lang.com/]]

Note that if you choose to use SCSS, you can:

* modify all the mixins provided by rails_admin and bootstrap and add others for you to use in `mixins.css.scss`. (available mixins [[here|https://github.com/thomas-mcdonald/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap/mixins.css.scss]])
* modify all the variables provided by rails_admin and bootstrap and add others for you to use in `variables.css.scss`. (available variables [[here|https://github.com/thomas-mcdonald/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap/variables.css.scss]])
* In `theming.css.scss`:
  * use all mixins and variables. (your owns, Bootstrap's and RailsAdmin's)
  * include any other .scss file with `@import rails_admin/themes/__THEME_NAME__/my_scss_file` and organize your the rest of your theme the way you want.

### JS

Use anything you want that the asset pipeline supports: regular JS, includes, Coffee, ..

### Images

You can use any image available to the asset pipeline.

### Use a theme

In your `Gemfile`:
```ruby
gem 'rails_admin_example_theme', :git => 'git://github.com/bbenezech/rails_admin_example_theme.git'
```

Inside `config/application.rb`, just after `Bundler.require`:
```ruby
ENV['RAILS_ADMIN_THEME'] = 'example_theme'
```

### Resources:

* [[Boostrap|http://twitter.github.com/bootstrap/]]
* [[Bootstrap Sass|https://github.com/thomas-mcdonald/bootstrap-sass]]

### Existing themes:

* [[Example theme|https://github.com/bbenezech/rails_admin_example_theme]]: technical stub you can use for bootstrapping. Everything should look painfully greenish.
* Designer of feel like one? Add your own.