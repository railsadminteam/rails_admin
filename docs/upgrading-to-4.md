# Upgrading to RailsAdmin 4.0

4.0 reworks how RailsAdmin's JavaScript and CSS are delivered. The headline: the
gem now ships a **prebuilt bundle**, so `:propshaft` and `:sprockets` apps need
no build step and no Node. Most apps only need to re-run the installer.

```bash
$ bin/rails g rails_admin:install
```

## `config.asset_source`

| Old value    | 4.0                                                                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `:sprockets` | unchanged — serves the prebuilt bundle                                                                                                      |
| `:webpack`   | still works, treated as `:external` (deprecation warning)                                                                                   |
| `:importmap` | falls back to the detected pipeline (`:propshaft` / `:sprockets`); RailsAdmin ships a bundle now, so importmap pins are no longer generated |
| `:webpacker` | **removed** — raises. Webpacker is EOL; use `:external`                                                                                     |
| `:vite`      | **removed** — raises. Use `:external` (Vite still builds it)                                                                                |
| —            | new: `:propshaft`, and a callable returning the `<head>` markup                                                                             |

Leaving it unset auto-detects. See [Asset delivery](asset-delivery.md).

## Customization moved off the Sprockets load path

The `app/assets/{stylesheets,javascripts}/rails_admin/custom/*` override files
and the `rails_admin/application.{js,css}` manifests are gone. To inject your own
tags, override `app/views/layouts/rails_admin/_head_custom.html.erb`:

```erb
<%# app/views/layouts/rails_admin/_head_custom.html.erb %>
<style nonce="<%= content_security_policy_nonce %>">
  body.rails_admin { --ra-nav-link-active-bg: #6f42c1; --ra-nav-link-active-color: #fff; }
</style>
```

This works under every `asset_source`. For Sass-level changes (Bootstrap
variables, extra `@import`s), use `:external` and edit the generated
`rails_admin.scss`. See [Theming and customization](theming-and-customization.md).

## Smaller changes

- **`sassc-rails`** is no longer required — the shipped CSS is plain.
- **Bootstrap 5.1 → 5.3**: Sprockets apps were served a vendored Bootstrap 5.1.3
  fork; the bundle is built from Bootstrap 5.3, so expect minor visual shifts.
  Other pipelines already resolved 5.3 from npm.
- **Font Awesome** ships as woff2 only; the `.ttf` fallback is gone.
- **flatpickr** now bundles every locale, so the date/time picker follows
  `I18n.locale` with no extra setup on any pipeline.
- **`@rails/ujs`** is no longer bundled (Rails dropped it from the default stack;
  Turbo covers what RailsAdmin used it for). If a host app renders old-style
  `link_to …, method: :delete` links **inside the RailsAdmin layout** and has no
  `@rails/ujs` of its own, switch those to `data: { turbo_method: :delete }` or
  add rails-ujs to your app.
- **ActionText**: no-build apps get the Trix editor from a CDN (attachment
  uploads still work). Use `:external` with `import "trix"` to serve it
  statically. See [ActionText](actiontext.md).

## `:external` apps

Re-run the installer to regenerate `app/javascript/rails_admin.{js,scss}` (the
import paths are unchanged: `rails_admin/src/rails_admin/base` and
`rails_admin/src/rails_admin/styles/base`). If you had added flatpickr locale
imports by hand, you can drop them — they're bundled now.
