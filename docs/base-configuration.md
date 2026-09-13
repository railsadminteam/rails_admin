RailsAdmin provides its out of the box administrative interface by inspecting your application's
models and following some Rails conventions. For a more tailored experience, it also provides a
configuration DSL which allows you to customize many aspects of the interface.

## Asset delivery

RailsAdmin ships a prebuilt bundle and serves it through your app's existing
pipeline; `config.asset_source` (`:propshaft` / `:sprockets` / `:external` / a
callable, auto-detected when unset) selects how. See
[Asset delivery](asset-delivery.md) for the full picture.

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
