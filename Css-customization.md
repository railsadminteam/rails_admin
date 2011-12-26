RailsAdmin uses a sass release of bootstrap for CSS, and bootstrap/jquery-ui for JS.

### For application level theming, override these files in your app:

* `app/assets/stylesheet/rails_admin/custom/mixins.css.scss`
* `app/assets/stylesheet/rails_admin/custom/theming.css.scss`
* `app/assets/stylesheet/rails_admin/custom/variables.css.scss`
* `app/assets/javascripts/rails_admin/custom/ui.js`

### For theme creation (you wish to share it with the community), create these files in your gem (or add it to RA with a pull request):

* `app/assets/stylesheet/rails_admin/theme/__THEME_NAME__/mixins.css.scss`
* `app/assets/stylesheet/rails_admin/theme/__THEME_NAME__/theming.css.scss`
* `app/assets/stylesheet/rails_admin/theme/__THEME_NAME__/variables.css.scss`
* `app/assets/javascripts/rails_admin/theme/__THEME_NAME__/ui.js`

### Use a theme

None has been released so far, but when it's been done, you can set `ENV['RAILS_ADMIN_THEME']` to the name of that theme inside your `application.rb`

! Note that initializers such as RailsAdmin's aren't read when !
```ruby
config.assets.initialize_on_precompile
```

### Resources:

* [[Boostrap|http://twitter.github.com/bootstrap/]]
* [[Bootstrap Sass|https://github.com/thomas-mcdonald/bootstrap-sass]]
