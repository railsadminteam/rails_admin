# Asset delivery

RailsAdmin ships a **prebuilt `rails_admin.js` and `rails_admin.css`** inside the gem (under `app/assets/builds`). For most applications there is nothing to build and nothing to configure — RailsAdmin serves those files through whatever asset pipeline your app already has.

`config.asset_source` selects how the `<head>` tags are produced. When it is left unset RailsAdmin auto-detects; set it explicitly in `config/initializers/rails_admin.rb` if the guess is wrong.

```ruby
RailsAdmin.config do |config|
  config.asset_source = :propshaft # :sprockets / :external / a callable / nil (auto)
end
```

## `:propshaft` / `:sprockets`

Serve the bundle shipped in the gem. No Node, no build step. This is the default for any app on Propshaft (Rails 8's default) or Sprockets.

```bash
$ rails g rails_admin:install --asset=propshaft   # or --asset=sprockets
```

Under `:sprockets`, `rails_admin.js` / `rails_admin.css` are added to `config.assets.precompile` automatically.

## `:external`

Use this when you want to build the bundle yourself — to change the Bootstrap theme at the Sass level, add JavaScript dependencies, or serve Trix without the CDN fallback (see below). The installer generates two entrypoints that re-export RailsAdmin's source:

```js
// app/javascript/rails_admin.js
import "rails_admin/src/rails_admin/base";
```

```scss
// app/assets/stylesheets/rails_admin.scss
$fa-font-path: "rails_admin";
@import "rails_admin/src/rails_admin/styles/base";
```

Add the `rails_admin` npm package and wire these into your bundler (esbuild, Webpack, Vite, Rollup, …) so they output `app/assets/builds/rails_admin.js` and `app/assets/builds/rails_admin.css`.

Wire them into the build scripts your bundler runs rather than invoking them by hand — those scripts are what `rails assets:precompile` runs on deploy.

With the esbuild and sass setup `jsbundling-rails` and `cssbundling-rails` generate, `app/javascript/rails_admin.js` is already covered by the `build` script's `app/javascript/*.*` glob, and the stylesheet needs one more pair in `build:css`:

```json
"build:css": "sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css ./app/assets/stylesheets/rails_admin.scss:./app/assets/builds/rails_admin.css --no-source-map --load-path=node_modules"
```

```bash
$ rails g rails_admin:install --asset=external
```

`--asset=webpack` and `--asset=vite` are accepted as aliases for `:external`.

## A callable

`config.asset_source` also accepts anything responding to `call(view)` that returns the `<head>` markup, for when you need to serve the assets some other way (a CDN, a bundler RailsAdmin does not know about, a digest lookup of your own, …). It is called on every render, and `view` is RailsAdmin's view context, so any helper your application has is available:

```ruby
config.asset_source = ->(view) do
  view.safe_join([
    view.stylesheet_link_tag("https://cdn.example.com/rails_admin.css"),
    view.javascript_include_tag("https://cdn.example.com/rails_admin.js", defer: true),
  ])
end
```

Return markup, not a bare string: whatever comes back is interpolated with `<%= %>`, so a plain `String` is HTML-escaped and lands in the page as text. Building the tags with helpers, as above, gives you that for free.

### Vite

Run the installer with `--asset=vite`, move the two generated entrypoints into the directory Vite builds (`app/javascript/entrypoints` by default), and render them with Vite's helpers:

```ruby
config.asset_source = lambda do |view|
  view.safe_join([
    view.vite_stylesheet_tag("rails_admin.scss"),
    view.vite_javascript_tag("rails_admin", defer: true),
  ])
end
```

One change is needed in the generated stylesheet. It ships with `$fa-font-path: "rails_admin"`, which resolves against the asset path where the gem keeps the Font Awesome face — Vite serves from its own output directory instead, so the face 404s and every icon disappears. Point it at the npm package and Vite bundles the font itself:

```scss
$fa-font-path: "@fortawesome/fontawesome-free/webfonts";
@import "rails_admin/src/rails_admin/styles/base";
```

### Import maps

An import map application needs none of this to run RailsAdmin: the bundle shipped in the gem is an IIFE, it never enters your import map, and `:propshaft` serves it alongside your own pinned JavaScript with no configuration at all.

Serving RailsAdmin's own modules through an import map is possible as well — draw a second map pinning `rails_admin/src/rails_admin/base` and its dependencies, and render it from the callable with `javascript_importmap_tags`, leaving the stylesheet to the prebuilt file in the gem. RailsAdmin generated those pins for you until 3.x and no longer does, so they are yours to write and to refresh on every upgrade; [the 3.x generator](https://github.com/railsadminteam/rails_admin/blob/v3.3.0/lib/generators/rails_admin/importmap_formatter.rb) shows the shape they took.

## What's in the bundle

- jQuery, jQuery UI (subset), Bootstrap 5, Popper, flatpickr (**all locales**), and RailsAdmin's own widgets
- `@hotwired/turbo-rails`
- `@rails/activestorage` and the `@rails/actiontext` glue, so Active Storage direct uploads and rich-text attachment uploads work out of the box

**Trix is not bundled.** When a `<trix-editor>` appears without `window.Trix`, RailsAdmin loads Trix from a CDN. To serve it statically, use `:external` and add `import "trix"` / `@import "trix/dist/trix"` to your entrypoints — see [ActionText](actiontext.md).

## Customizing without a build

Override `app/views/layouts/rails_admin/_head_custom.html.erb` to inject your own tags into RailsAdmin's `<head>`, and use the `--ra-*` CSS custom properties to retheme the chrome — both work under every `asset_source`. See [Theming and customization](theming-and-customization.md).

## Rebuilding the shipped assets (contributors)

`npm run build` (or `bundle exec rake rails_admin:build_assets`) regenerates `app/assets/builds` from `src/`. CI fails if the committed output is stale, and `rake release` aborts on an uncommitted rebuild.
