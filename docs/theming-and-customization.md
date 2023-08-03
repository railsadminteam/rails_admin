# Theming and customization

RailsAdmin uses a sass release of bootstrap for CSS, and bootstrap/jquery-ui for JS.

### For custom theming (application scoped), simply override these files in your app:

```
app/assets/stylesheets/rails_admin/custom/mixins.scss
app/assets/stylesheets/rails_admin/custom/theming.scss
app/assets/stylesheets/rails_admin/custom/variables.scss
app/assets/javascripts/rails_admin/custom/ui.js
```

Don't forget to re-compile your assets or simply delete the content of your `tmp/cache` folder. Some additional steps might be required, as others reported here: https://github.com/railsadminteam/rails_admin/issues/738#issuecomment-26615578

RailsAdmin uses jquery-pjax (https://github.com/defunkt/jquery-pjax) to load pages instead normal HTTP requests, use `$(document).on('rails_admin.dom_ready', function(){ /* your js code here */ });` instead jQuery's default on ready function `$(function(){ /* your js code here */ });` to check if page is loaded. It will work to both normal and pjax requests.

### To create a distributable theme

```
rails plugin new rails_admin_<__THEME_NAME__> -m https://gist.githubusercontent.com/bbenezech/1523639/raw/42579a263c219d111c03936f93ff25a7d8999bda/rails_admin_theme_creator --skip-gemfile --skip-bundle -T -O --full
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

Put all the real theming in `theming.css.scss`. It can be regular CSS, LESS or [SCSS](http://sass-lang.com/)

Note that if you choose to use SCSS, you can:

- modify all the mixins provided by rails_admin and bootstrap and add others for you to use in `mixins.scss`. (available mixins [here](https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_mixins.scss))
- modify all the variables provided by rails*admin and bootstrap and add others for you to use in `variables.scss`. Note that the variables in `variables.scss` are imported before Bootstrap's variables which all have set the [!default](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#variable_defaults*) flag. This effectively means that you can customize chained variables by just assigning a custom value to the first one instead of the need to override each single one. E.g. you do not have to override `$btn-success-bg`, `$label-succes-bg` and `$progress-bar-success-bg` but only assign a custom value to `$brand-success`. (available variables [here](https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_variables.scss))
- In `theming.scss`:
  - use all mixins and variables. (your owns, Bootstrap's and RailsAdmin's)
  - include any other .scss file with `@import rails_admin/themes/__THEME_NAME__/my_scss_file` and organize your the rest of your theme the way you want.

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

- [Bootstrap](http://twitter.github.com/bootstrap/)
- [Bootstrap Sass](https://github.com/thomas-mcdonald/bootstrap-sass)

### Existing themes:

- [Example theme](https://github.com/bbenezech/rails_admin_example_theme): technical stub you can use for bootstrapping. Everything should look painfully greenish.
- [Flatly theme](https://github.com/konjoot/rails_admin_flatly_theme): Bootstrap 2 flatly theme.
- [Rails Admin Material](https://github.com/blocknotes/rails_admin_material): A Material design theme.
- [Rollincode theme](https://github.com/rollincode/rails_admin_theme): Bootstrap 3 flat theme.
- [SoftwareBrothers theme](https://github.com/SoftwareBrothers/rails_admin_softwarebrothers_theme): SoftwareBrothers theme
- Designer, or feel like one? Add your own.
