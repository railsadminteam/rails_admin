# Asset delivery

RailsAdmin ships a **prebuilt `rails_admin.js` and `rails_admin.css`** inside the
gem (under `app/assets/builds`). For most applications there is nothing to build
and nothing to configure — RailsAdmin serves those files through whatever asset
pipeline your app already has.

`config.asset_source` selects how the `<head>` tags are produced. When it is left
unset RailsAdmin auto-detects; set it explicitly in
`config/initializers/rails_admin.rb` if the guess is wrong.

```ruby
RailsAdmin.config do |config|
  config.asset_source = :propshaft # :sprockets / :external / a callable / nil (auto)
end
```

## `:propshaft` / `:sprockets`

Serve the bundle shipped in the gem. No Node, no build step. This is the default
for any app on Propshaft (Rails 8's default) or Sprockets.

```bash
$ rails g rails_admin:install --asset=propshaft   # or --asset=sprockets
```

Under `:sprockets`, `rails_admin.js` / `rails_admin.css` are added to
`config.assets.precompile` automatically.

## `:external`

Use this when you want to build the bundle yourself — to change the Bootstrap
theme at the Sass level, add JavaScript dependencies, or serve Trix without the
CDN fallback (see below). The installer generates two entrypoints that re-export
RailsAdmin's source:

```js
// app/javascript/rails_admin.js
import "rails_admin/src/rails_admin/base";
```

```scss
// app/javascript/rails_admin.scss
$fa-font-path: "rails_admin";
@import "rails_admin/src/rails_admin/styles/base";
```

Add the `rails_admin` npm package and wire these into your bundler (esbuild,
Webpack, Vite, Rollup, …) so they output `app/assets/builds/rails_admin.js` and
`app/assets/builds/rails_admin.css`.

```bash
$ rails g rails_admin:install --asset=external
```

`--asset=webpack` and `--asset=vite` are accepted as aliases for `:external`.

## A callable

`config.asset_source` also accepts anything responding to `call(view)` that
returns the `<head>` markup, for when you need to serve the assets some other
way (a CDN, a digest lookup of your own, …):

```ruby
config.asset_source = ->(view) do
  view.safe_join([
    view.stylesheet_link_tag("https://cdn.example.com/rails_admin.css"),
    view.javascript_include_tag("https://cdn.example.com/rails_admin.js", defer: true),
  ])
end
```

## What's in the bundle

- jQuery, jQuery UI (subset), Bootstrap 5, Popper, flatpickr (**all locales**),
  and RailsAdmin's own widgets
- `@hotwired/turbo-rails`
- `@rails/activestorage` and the `@rails/actiontext` glue, so Active Storage
  direct uploads and rich-text attachment uploads work out of the box

**Trix is not bundled.** When a `<trix-editor>` appears without `window.Trix`,
RailsAdmin loads Trix from a CDN. To serve it statically, use `:external` and add
`import "trix"` / `@import "trix/dist/trix"` to your entrypoints — see
[ActionText](actiontext.md).

## Customizing without a build

Override `app/views/layouts/rails_admin/_head_custom.html.erb` to inject your own
tags into RailsAdmin's `<head>`, and use the `--ra-*` CSS custom properties to
retheme the chrome — both work under every `asset_source`. See
[Theming and customization](theming-and-customization.md).

## Rebuilding the shipped assets (contributors)

`npm run build` (or `bundle exec rake rails_admin:build_assets`) regenerates
`app/assets/builds` from `src/`. CI fails if the committed output is stale, and
`rake release` aborts on an uncommitted rebuild.
