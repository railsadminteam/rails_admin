<div align="center">

# RailsAdminNext

### The modern RailsAdmin — point it at your ActiveRecord models for instant CRUD, search, filtering, export, and history.

**Rails ~> 8.1 · ActiveRecord · importmap + Propshaft · Turbo + Stimulus · zero build step**

[![Build](https://github.com/6temes/rails_admin_next/actions/workflows/ci.yml/badge.svg)](https://github.com/6temes/rails_admin_next/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.md)
[![Ruby](https://img.shields.io/badge/Ruby-4.0.10%2B-CC342D.svg)](https://www.ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.1-CC0000.svg)](https://rubyonrails.org)

[Why RailsAdminNext?](#why-railsadminnext) ◆ [Quick Start](#quick-start) ◆ [Installation](#installation) ◆ [Architecture](#architecture) ◆ [Security](#security) ◆ [Upgrading](#upgrading-from-railsadmin)

</div>

RailsAdminNext is a Rails engine that auto-generates an easy-to-use interface for managing your
data — a modernized hard fork of [RailsAdmin][upstream], restarted at 1.0.0 and trimmed to a single,
modern, zero-build stack. There is no Mongoid, no Webpack/Webpacker/Vite/Sprockets, no jQuery, and
no build step.

Already running RailsAdmin? See [docs/UPGRADING.md](docs/UPGRADING.md).

[upstream]: https://github.com/railsadminteam/rails_admin

## Why RailsAdminNext?

RailsAdmin gives you a full admin UI for free — but the original carries a decade of multi-ORM,
multi-bundler, jQuery-era machinery. RailsAdminNext keeps the admin and drops the rest:

- **⚡ Zero build step** — browser-native ESM over **importmap + Propshaft**; no Webpack/Vite/Sprockets, no `yarn build`, no generated pins.
- **🧩 Turbo + Stimulus** — the jQuery / jQuery-UI / Bootstrap-JS / `@rails/ujs` stack is gone, replaced by engine-shipped Stimulus controllers; styling is hand-maintained vanilla CSS.
- **🔒 Hardened & CDN-free** — a documented CSRF / clickjacking / mass-assignment / CSP posture ([SECURITY.md](SECURITY.md)) and **zero external CDN**, default or opt-in — every asset is self-hosted off a gem.
- **🎯 One modern target** — Ruby ≥ 4.0.10, Rails ~> 8.1, ActiveRecord only, latest Chrome + Safari. No Mongoid, no multi-bundler / multi-Rails matrix, no legacy-browser CSS.
- **↩️ Familiar** — `RailsAdminNext.config`, per-model `rails_admin_next do … end` blocks, and Pundit authorization all work as before; upgrading from RailsAdmin is a mechanical rename.

## Quick Start

```ruby
# Gemfile
gem "rails_admin_next", git: "https://github.com/6temes/rails_admin_next"
```

```bash
bundle install
bin/rails g rails_admin_next:install   # mounts the engine + writes the initializer
bin/rails s                            # then open http://localhost:3000/admin
```

That's the whole setup — no `yarn add`, no asset build, no generated pins. The engine ships its own importmap and CSS.

> **Prerequisites:** Ruby ≥ 4.0.10 · Rails ~> 8.1 · ActiveRecord · a [Propshaft][propshaft] + [importmap-rails][importmap] host (both are pulled in as dependencies). See [Installation](#installation) for the full walkthrough.

## Requirements

- Ruby >= 4.0.10
- Rails ~> 8.1
- ActiveRecord (Mongoid is not supported)
- [Propshaft][propshaft] and [importmap-rails][importmap] (both are pulled in as
  dependencies; RailsAdminNext serves its frontend over them, with no bundler or build step)
- Latest stable Chrome or Safari for the admin's users (see [Browser support](#browser-support))

RailsAdminNext expects **evergreen** hosts. The Ruby floor follows the latest stable Ruby
patch release, and a release can raise it without a major version bump. Keep your app on
current Ruby and Rails to keep receiving updates.

[propshaft]: https://github.com/rails/propshaft
[importmap]: https://github.com/rails/importmap-rails

## Installation

1. Add the gem to your `Gemfile`. RailsAdminNext is distributed from the fork, so point
   at the repository with `git:`:

   ```ruby
   gem "rails_admin_next", git: "https://github.com/6temes/rails_admin_next"
   ```

2. Run `bundle install`.
3. Run `rails g rails_admin_next:install`.
4. Provide a namespace for the routes when asked (defaults to `admin`).
5. Start a server with `rails s` and administer your data at
   [/admin](http://localhost:3000/admin) (or the namespace you chose).

The install generator mounts the engine, writes
`config/initializers/rails_admin_next.rb`, and does nothing else — the engine ships its
own importmap and CSS, so there is no `yarn add`, no asset build, and no generated pins.

### Agent skill

RailsAdminNext is a [Rails Hyperdrive][hyperdrive] companion gem. It ships a
`rails-admin-next` skill that teaches coding agents this fork's API rather than upstream
RailsAdmin's. In an app running Hyperdrive, sync installs the skill, and each later
release updates it:

```bash
bin/rails hyperdrive:sync
```

The skill points agents at the `docs/*.md` files packaged in the gem, so its references
always match the installed version.

[hyperdrive]: https://github.com/rails-hyperdrive/rails-hyperdrive

## Features

- CRUD any data with ease
- Custom actions
- Automatic form validation
- Search and filtering
- Export data to CSV / JSON / XML
- File uploads (ActiveStorage)
- Rich text fields (ActionText / Trix)
- Authentication (via [Devise][devise] or any other scheme)
- Authorization (via [Pundit][pundit], [ActionPolicy][action_policy] or a custom adapter)
- User action history (via [PaperTrail][papertrail])

[devise]: https://github.com/heartcombo/devise
[pundit]: https://github.com/varvet/pundit
[action_policy]: https://github.com/palkan/action_policy
[papertrail]: https://github.com/paper-trail-gem/paper_trail

## Configuration

### Global

Configure the engine in `config/initializers/rails_admin_next.rb`:

```ruby
RailsAdminNext.config do |config|
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
```

This is also where you wire up [Devise][devise], [Pundit][pundit], and [PaperTrail][papertrail].

Every admin page ends with a small "Made in Tokyo with ❤️ and 🤖" footer. To hide it:

```ruby
RailsAdminNext.config do |config|
  config.show_footer = false
end
```

### Per model

Configure a model inline with the `rails_admin_next do … end` class macro:

```ruby
class Ball < ApplicationRecord
  validates :name, presence: true
  belongs_to :player

  rails_admin_next do
    configure :player do
      label "Owner of this ball: "
    end
  end
end
```

The configuration DSL is unchanged from upstream RailsAdmin, so the upstream
[wiki][wiki] is still an accurate reference for model, group, and field options.

[wiki]: https://github.com/railsadminteam/rails_admin/wiki

### Authorization keys are stable

The authorization contract is held stable, so existing Pundit policies keep working
**without edits**: every action's authorization key (`:dashboard`, `:index`, `:show`,
`:new`, `:edit`, `:export`, `:destroy`, `:history`, `:show_in_app`) is unchanged, and the
Pundit adapter calls it with a `?` suffix (`index?`, `edit?`). Pundit and ActionPolicy are
the built-in adapters; any other authorization library plugs in as a custom adapter, which by convention
checks the `:access, :rails_admin` subject. See [docs/UPGRADING.md](docs/UPGRADING.md).

The `admin.*` I18n namespace is likewise unchanged.

### ActionPolicy

`config.authorize_with :action_policy` checks each action against the record's policy with
the same `<key>?` rules the Pundit adapter calls (`index?`, `show?`, `new?`, `edit?`,
`destroy?`, `export?`, `history?`, `show_in_app?`, `dashboard?`), and scopes lists, export
and bulk delete through the policy's default `relation_scope`. A model with no policy, or a
policy with no default relation scope, lists nothing. Policies that declare context beyond
`user` get it from `authorize_with :action_policy, context: {...}`. Bundle `action_policy` yourself; see
the "ActionPolicy adapter" section of [docs/UPGRADING.md](docs/UPGRADING.md).

## Frontend and assets

RailsAdminNext ships a single, zero-build asset path:

- The pipeline is **importmap + Propshaft** only.
- The frontend is **Turbo + Stimulus** — the engine ships its own Stimulus application
  and controllers under `src/rails_admin/`, registered through an explicit manifest
  (`src/rails_admin/controllers/index.js`).
- Styles are **hand-maintained vanilla CSS** (no Bootstrap SCSS, no build), delivered in
  cascade layers with a design-token theming API — see
  [Styling and theming](#styling-and-theming). Icons are inline SVG, and date/time fields
  use native HTML5 inputs — no icon font, no date-picker library.

Compared to RailsAdmin, the following were intentionally removed:

- **Mongoid** — ActiveRecord only.
- **Webpack, Webpacker, Vite, and Sprockets** — importmap + Propshaft only.
- **jQuery, jQuery-UI, Bootstrap's JS, and `@rails/ujs`** — replaced by Stimulus controllers.
- **Standalone WYSIWYG/code editors** (`bootstrap-wysihtml5`, `froala`, CKEditor, CodeMirror,
  SimpleMDE) — they loaded from a CDN; use ActionText/Trix rich text (self-hosted) or a plain
  `:text` textarea instead.
- **Drag-to-reorder for multiple uploads** (it relied on jQuery-UI sortable).
- **flatpickr** — date/time fields use native HTML5 inputs (`type="date"`/`datetime-local`/`time`);
  the configurable picker display format and localization are now the browser's.

### Browser support

RailsAdminNext is built as an **internal tool for teams that control their admin users'
browsers**: it targets the **latest stable Chrome and Safari only**, and it drops
legacy-browser support deliberately — it does not court general RailsAdmin migrators. The
engine's CSS and JS freely assume `:has()`, `<dialog>`, popovers, CSS nesting, `oklch()`,
`color-mix()`, `light-dark()`, and CSS anchor positioning. If your admin users are on
Firefox or anything older, stay on upstream RailsAdmin.

### Styling and theming

All engine CSS ships inside three cascade layers — `ra.tokens`, `ra.framework`, `ra.skin` —
so **any unlayered host rule beats the engine's CSS** without specificity games:

```css
/* a plain rule in your own stylesheet just wins */
.badge {
  border-radius: 7px;
}
```

Re-branding is one token — every derived color (button hover/active states, focus rings,
links, alert tints) follows automatically:

```css
:root {
  --ra-primary: #663399;
}
```

See [docs/UPGRADING.md](docs/UPGRADING.md) for the full list of supported override tokens
and the `--bs-*` → `--ra-*` mapping.

### Dark mode

The admin follows the OS color-scheme preference automatically (every color token is a
`light-dark()` pair). The `color_scheme` config knob pins it:

```ruby
RailsAdminNext.config do |config|
  config.color_scheme = :light # :auto (default) follows the OS; :light/:dark pin it
end
```

**Note for operators:** after upgrading, the admin renders dark for anyone whose OS prefers
dark. Pin `config.color_scheme = :light` to keep the old always-light rendering; if
something looks wrong in dark mode, please
[open an issue](https://github.com/6temes/rails_admin_next/issues).

## Architecture

RailsAdminNext is built on a handful of registries and one ORM facade: a **single controller with no
action methods**, where each admin operation is an object.

```text
              Host app models (ActiveRecord)
                          │
              RailsAdminNext.config(Model) { … }        ← lazy, proxy-bound DSL
                          │   (deferred; evaluated on first access)
                          ▼
   ┌──────────────────────────────────────────────────────────────┐
   │  Action registry — Config::Actions::Base subclasses           │
   │  dashboard · index · show · new · edit · delete · export ·    │
   │  bulk_delete · history_* · show_in_app                        │
   │  each carries: route scope · http_methods · template ·        │
   │  authorization_key · a :controller proc (the request handler) │
   └──────────────────────────┬───────────────────────────────────┘
                          │  routes drawn dynamically at boot
                          ▼
      RailsAdminNext::MainController   (ONE controller, no actions)
        method_missing → authorize → load @object → eval the proc
                          │
                          ▼
      RailsAdminNext::AbstractModel  →  Adapters::ActiveRecord
        get · first · all · count · scoped · destroy · new
        (StatementBuilder generates the filter/search SQL, per adapter)
                          │
                          ▼
      Views + Turbo/Stimulus (src/rails_admin/*) over importmap + Propshaft
```

**Key design decisions:**

- **One controller, many action objects** — to change how e.g. _edit_ behaves, edit `lib/rails_admin_next/config/actions/edit.rb`, not the controller.
- **ORM facade** — nothing outside `AbstractModel` references ActiveRecord directly; the adapter seam is intact even though Mongoid was removed.
- **Lazy, layered config** — `config/initializers` blocks run before in-model `rails_admin_next do … end` blocks, so per-model config overrides the initializer defaults.
- **A deliberately frozen `rails_admin` surface** — the Ruby layer is `RailsAdminNext`, but the action authorization keys, the `admin.*` I18n namespace, and the `src/rails_admin/` asset tree stay `rails_admin`-era on purpose, so host policies, translations, and assets keep working across the rename.

## Upgrading from RailsAdmin

See [docs/UPGRADING.md](docs/UPGRADING.md) for the one-time changes a host app needs:
the Gemfile gem name, the importmap/Propshaft prerequisites, and a mechanical rename of the
`RailsAdmin` constant, initializer, mount, model macro, and route helpers to `RailsAdminNext`
(`rails_admin_next`). The action authorization keys and the `admin.*` I18n namespace are
deliberately left unchanged, so Pundit policies and translations keep working without edits.
Its 2.0 section covers hosts whose authorization library is no longer a built-in adapter.

## Security

For supported versions, private vulnerability reporting, the automated scanning gates,
and the manual importmap-pin audit cadence, see [SECURITY.md](SECURITY.md). The admin's
request-forgery, clickjacking, export, mass-assignment, and Content-Security-Policy
posture is documented in [docs/security.md](docs/security.md).

## Contributing

Bug reports and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the
development setup and how to run the test suite. If you think you found a bug, please
[open an issue](https://github.com/6temes/rails_admin_next/issues/new).

## Credits

This project is a hard fork of the original [RailsAdmin][upstream], created by
Erik Michaels-Ober, Bogdan Gaza, Petteri Kääpä, Benoit Bénézech, Mitsuhiro Shibuya, and the
many contributors who built and maintained it for over a decade. It stands entirely on their
work. This fork is independent and is not affiliated with or endorsed by the RailsAdmin
maintainers.

## License

RailsAdminNext is released under the [MIT License](LICENSE.md).

---

<div align="center">
  <sub>Made in Tokyo with ❤️ and 🤖</sub>
</div>
