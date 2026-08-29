RailsAdmin provides its out of the box administrative interface by inspecting your application's
models and following some Rails conventions. For a more tailored experience, it also provides a
configuration DSL which allows you to customize many aspects of the interface.

## Asset delivery

Rails 7.0 drastically changed the way it integrates with JavaScript and CSS. RailsAdmin is made to be compatible with the change and it supports multiple asset delivery methods that are described in this section.

For setting up the asset delivery, [the RailsAdmin installer](https://github.com/railsadminteam/rails_admin#installation) will basically auto-detect the asset delivery method and perform necessary configurations depending on the method it choose. But you can also manually specify the method to use.

```bash
$ rails g rails_admin:install --asset=sprockets
```

Once installation is finished, you can find the current asset delivery method in `config/initializers/rails_admin.rb`.

```ruby
RailsAdmin.config do |config|
  config.asset_source = :sprockets
end
```

### `:propshaft` / `:sprockets` (default)

RailsAdmin ships a prebuilt `rails_admin.js` / `rails_admin.css` in the gem and
serves it through whichever pipeline your app already uses. There is no build
step and nothing to configure.

```bash
$ rails g rails_admin:install --asset=propshaft   # or --asset=sprockets
```

### `:external`

Use this when you want to build the bundle yourself - to change the Bootstrap
theme, add dependencies, or avoid the CDN fallback for Trix. The installer
generates `app/javascript/rails_admin.js` and `app/javascript/rails_admin.scss`
that re-export `rails_admin/src/rails_admin/base`; wire them into your bundler
(esbuild, Webpack, Vite, ...) so they output
`app/assets/builds/rails_admin.{js,css}`.

```bash
$ rails g rails_admin:install --asset=external
```

Passing `--asset=webpack` or `--asset=vite` is treated as `:external`.

### A callable

`config.asset_source` also accepts anything responding to `call(view)` that
returns the `<head>` markup, if you need to serve the assets some other way.

## Set the application name

```ruby
RailsAdmin.config do |config|
  config.main_app_name = ["Cool app", "BackOffice"]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| [ "Cool app", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }
end
```

## Locale

To set locale for RailsAdmin - use a custom parent controller and add an `around_action` to execute the request in the context of a given locale, ie.

```ruby
# initializers/rails_admin.rb
RailsAdmin.config do |config|
  config.parent_controller = "Admin::BaseController"
end

# controllers/admin/base_controller.rb
class Admin::BaseController < ActionController::Base
  around_action :use_default_locale

  private

  def use_default_locale(&block)
    # Executes the request with the I18n.default_locale.
    # https://github.com/ruby-i18n/i18n/commit/9b14943d5e814723296cd501283d9343985fca4e
    I18n.with_locale(I18n.default_locale, &block)
  end
end
```

[Related Rails Guides](https://guides.rubyonrails.org/i18n.html#managing-the-locale-across-requests)

## Authentication integration (Devise, Sorcery, Manual)

[Authentication](authentication.md)

## Authorization (Cancancan, Pundit)

[Authorization](authorization.md)

## Instance labels

```ruby
config.label_methods << :description # Default is [:name, :title]
```

## Browser validations

```ruby
config.browser_validations = false # Default is true
```

**Next**

Then you can start adding [actions](actions.md), configuring [models](models.md), [sections](base.md) and [fields](fields.md).
