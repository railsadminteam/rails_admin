# Upgrading from rails_admin to rails_admin_next

`rails_admin_next` is the modernized fork of `rails_admin`: Rails 8.1 / Ruby 4.0.10 floor,
ActiveRecord only, an importmap + Propshaft asset pipeline, a Stimulus + Turbo
frontend (no jQuery, jQuery-UI, Bootstrap JS, or `@rails/ujs`), vanilla CSS with a
latest-Chrome/Safari browser floor, and a hardened security posture. This guide covers
the one-time changes a host app needs.

The Ruby namespace is renamed **`RailsAdmin` → `RailsAdminNext`** (and `rails_admin` →
`rails_admin_next`), so your initializer, engine mount, model macros, and route helpers
need a mechanical rename. The **authorization contract is deliberately unchanged** — every
action's authorization key and the `admin.*` I18n namespace stay exactly as they were, so
your Pundit policies and translations need no edits. CanCanCan is no longer a built-in
adapter; see the 2.0 section below.

## 2.0: CanCanCan support removed

Pundit and ActionPolicy are the built-in authorization adapters.
`config.authorize_with :cancancan` now raises `ArgumentError` while the initializer loads,
listing the registered adapters. Any other unregistered key does the same. Move to Pundit,
move to ActionPolicy (see [ActionPolicy adapter](#actionpolicy-adapter)), or keep CanCanCan
with a custom adapter.

### Move to Pundit

```ruby
RailsAdminNext.config do |config|
  config.authorize_with :pundit
end
```

- **`ApplicationPolicy`.** The adapter falls back to `::ApplicationPolicy` for the dashboard
  (record `nil`) and for any model without a policy of its own or a parent model's (see
  [STI subclasses use their parent model's policy](#sti-subclasses-use-their-parent-models-policy)).
- **Action predicates.** The adapter calls each action's authorization key with a `?`
  suffix: `dashboard?`, `index?`, `show?`, `new?`, `edit?`, `export?`, `destroy?`,
  `history?` and `show_in_app?`. Saving a new record also calls `create?`, and saving an
  edit calls `update?`. Member actions pass the record; list-level checks pass the class.
  `edit?` and `destroy?` also get the class: the form's "Save and edit" button checks
  `edit?`, and the index's bulk-delete menu checks `destroy?`. A predicate that reads record
  attributes must handle a class, for example `!record.is_a?(Class) && record.active?`.
- **A `Scope` for every model the admin lists.** A model whose policy resolves no `Scope`
  lists nothing (see
  [Pundit: a model with no policy Scope lists nothing](#pundit-a-model-with-no-policy-scope-lists-nothing)).
  A policy that subclasses `ApplicationPolicy` without its own `Scope` inherits
  `ApplicationPolicy::Scope`, so that class's `resolve` decides what the model lists.
- **Optional `attributes_for(action)`** on a policy returns the attributes a new record
  starts with, for example `{suspended: true}` for `:new`.

Three differences from CanCanCan to check before switching:

- **One `Scope` bounds every list.** The adapter passes no action to the `Scope`, so the same
  scope bounds index, export, bulk delete and the dashboard count. Bulk delete also asks
  `destroy?` of each selected record, but export does not. If an ability allowed export on
  fewer records than read, resolve the `Scope` to the narrowest of them, or stay on a custom
  adapter whose `query` honours the action.
- **Nothing checks `:access, :rails_admin`.** Admin access is decided by the same policies,
  and the `ApplicationPolicy` fallback, that the rest of the app uses. If those admit
  ordinary users, gate admin entry separately: in `config.authenticate_with`, or with
  admin-specific `authorization_key` values per action.
- **The block form only gates entry.** `config.authorize_with { ... }` runs before every
  action, but it checks no records and does not scope lists.

### Keep CanCanCan with a custom adapter

Register an adapter before the `RailsAdminNext.config` block that names its key, or the
`ArgumentError` above fires at boot:

```ruby
RailsAdminNext.add_extension(:cancancan, MyApp::CanCanCanAdmin, authorization: true)

RailsAdminNext.config do |config|
  config.authorize_with :cancancan
end
```

The module defines an `AuthorizationAdapter` class. `authorize_with` builds it with
`new(controller, *args, **options, &block)`. It must publicly define the first four methods
below; `authorize_with` raises `ArgumentError` while the initializer loads, naming any that are
missing or private:

- `authorize(action, abstract_model, object)`: raises when the action is denied.
- `authorized?(action, abstract_model, object)`: returns a boolean, for links and buttons.
- `query(action, abstract_model)`: returns the scope lists, export and bulk actions read from.
- `attributes_for(action, abstract_model)`: returns the attributes a new record starts with.
- `self.setup` (optional): runs once when `authorize_with` names the key.
- `self.validate_options!(*args, **options)` (optional): receives the extra arguments while the
  config block runs; raise `ArgumentError` there so a misconfigured option fails at boot. A
  subclass of a built-in adapter inherits its `validate_options!`, so one that takes options of
  its own overrides it.

An adapter that a `config.authorize_with { ... }` block assigns to `@authorization_adapter` is not
checked at boot; if it lacks `authorize`, the first admin action raises `NoMethodError` instead of
running unauthorized.

`lib/rails_admin_next/extensions/pundit/authorization_adapter.rb` in the gem is the template.
The removed CanCanCan adapter is a starting point you can copy:
[v1.3.0 `extensions/cancancan/authorization_adapter.rb`](https://github.com/6temes/rails_admin_next/blob/v1.3.0/lib/rails_admin_next/extensions/cancancan/authorization_adapter.rb),
with its module in `extensions/cancancan.rb` at the same tag. Abilities keep granting
`can :access, :rails_admin`.

## 1. Gemfile

Replace the upstream `rails_admin` gem with the fork (distributed via `git:`):

```ruby
# Gemfile
gem 'rails_admin_next', git: 'https://github.com/6temes/rails_admin_next'
```

Remove the old `gem 'rails_admin'` line, then `bundle install`.

## 2. Application code — rename the namespace

Rename `RailsAdmin` → `RailsAdminNext` and `rails_admin` → `rails_admin_next` in your
initializer, mount, per-model blocks, and route-helper calls:

```ruby
# config/initializers/rails_admin_next.rb  (renamed from config/initializers/rails_admin.rb)
RailsAdminNext.config do |config|
  config.model User do
    # …
  end

  # DELETE this line if your old initializer had it — the option was removed
  # (there is a single importmap + Propshaft pipeline now; leaving it in place
  # only logs a deprecation warning):
  # config.asset_source = :importmap
end

# config/routes.rb
mount RailsAdminNext::Engine => '/admin', as: 'rails_admin_next'

# per-model blocks
class Team < ApplicationRecord
  rails_admin_next do
    field :name
  end
end

# route helpers — these also hide in mailers and regular views
# (`rails_admin_url(...)` → `rails_admin_next_url(...)`) and inside field blocks
# (`bindings[:view].rails_admin.show_path(...)` → `bindings[:view].rails_admin_next.show_path(...)`)
rails_admin_next.dashboard_path
rails_admin_next.edit_path(model_name: 'team', id: team.id)
```

**Keep the mount alias `rails_admin_next`.** The engine's own views resolve routes through
the `rails_admin_next` route proxy, so the mount must expose that helper name — either
`as: 'rails_admin_next'` as above, or no `as:` at all (it defaults to the engine name).
Aliasing the mount to something else to preserve old helper names (e.g. `as: 'rails_admin'`)
breaks every engine page at render time with
`undefined local variable or method 'rails_admin_next'`.

Find every host-side call site that needs the rename with:

```bash
grep -rnE 'rails_admin_url|rails_admin_path|\.rails_admin\.' app config
```

Running `rails g rails_admin_next:install` writes the new initializer and mount for you.

## 3. Icons (`link_icon` / `navigation_icon`)

Font Awesome is **no longer shipped** (no icon font, no `font-awesome.css`). Icons now
render as inline SVG, and the icon options take a **logical icon name** (a Symbol or
String) instead of a Font Awesome class string:

```ruby
# Before
RailsAdminNext.config do |config|
  config.model Team do
    navigation_icon 'fas fa-trophy'
  end
  config.actions do
    # …
    my_custom_action { link_icon 'fas fa-rocket' }
  end
end

# After
RailsAdminNext.config do |config|
  config.model Team do
    navigation_icon :list      # a logical name (see the list below)
  end
  config.actions do
    my_custom_action { link_icon :show_in_app }
  end
end
```

Available logical names (see `RailsAdminNext::Icons::GLYPHS`):

`:dashboard` (alias `:home`), `:list`, `:show` (alias `:info`), `:new` (alias `:add`/`:plus`),
`:edit` (alias `:pencil`), `:delete` (aliases `:cancel`/`:times`), `:export`,
`:history` (alias `:book`), `:show_in_app` (alias `:eye`), `:bulk_delete` (alias `:question`),
`:collapse`, `:expand`, `:calendar`, `:check`, `:minus`, `:refresh` (alias `:sync`),
`:trash`, `:move_right`, `:move_left`, `:move_up`, `:move_down`.

**Legacy Font Awesome strings still given to `link_icon`/`navigation_icon` are handled
gracefully**: the glyph is best-effort mapped to the nearest logical name and a deprecation
warning is emitted (`RailsAdminNext.deprecator`); a value that can't be mapped renders no
icon rather than raising. Migrate to logical names to silence the warning. If you relied on
Font Awesome classes elsewhere in your own admin views, vendor Font Awesome yourself — the
engine no longer provides it.

## Authorization (no change needed)

The authorization contract is held stable — **do not touch your policies**:

- Every action's authorization key (`:dashboard`, `:index`, `:show`, `:new`, `:edit`,
  `:export`, `:destroy`, `:history`, `:show_in_app`) is unchanged.
- A custom adapter keeps the `:access, :rails_admin` subject by convention.

```ruby
# A custom CanCanCan adapter's ability still grants access with:
can :access, :rails_admin
```

The authorization keys are locked by a spec in the gem — a renamed key can fail *open* (a
deny rule that no longer matches silently grants access).

## Asset prerequisites

RailsAdminNext ships its frontend over **importmap + Propshaft** only — there is no
build step and no Sprockets/Webpacker/Webpack/Vite support. The host app must use:

- **Propshaft** (`config.assets.*` via `propshaft`), and
- **importmap-rails**.

Optional:

- **Thruster** in front of the app for edge caching of the fingerprinted assets.
- Set `config.assets.integrity_hash_algorithm` if you want Subresource Integrity on the
  engine's self-hosted modules (off by default; same-origin hosting makes SRI low-value).

## Browser support

The frontend targets the **latest stable Chrome and Safari only**. This fork is an internal
tool for teams that control their admin users' browsers; the old "Baseline 2023 /
Firefox ≥ 111" contract is retired deliberately, and no legacy-browser fallbacks ship. The
engine's CSS and JS assume `:has()`, `<dialog>`, popovers, CSS nesting, `oklch()`,
`color-mix()`, `light-dark()`, `@starting-style`, and CSS anchor positioning.

Two features are newer still: `closedby="any"` (backdrop light-dismissal of the inline-edit
dialog) needs Chromium 134+ / Safari 26, and CSS anchor positioning needs Chromium 128+ /
Safari 26 (dropdown menus are positioned by anchor CSS alone — no JS fallback ships).
`field-sizing: content` (auto-growing textareas) is a Chromium-only enhancement — other
browsers keep fixed-height textareas.

## Styling: cascade layers and design tokens

Bootstrap's SCSS is gone. Styling is hand-maintained vanilla CSS delivered through three
cascade layers, declared in `rails_admin.css` (the layer names are a documented contract):

- `ra.tokens` — design tokens (CSS custom properties)
- `ra.framework` — the trimmed ex-Bootstrap component CSS
- `ra.skin` — the engine's own widgets, icons, and admin skin

Because all engine CSS is layered, **any unlayered host rule beats it** — a plain rule in
your own stylesheet overrides the admin without `!important` or specificity games:

```css
/* host stylesheet — no layer, so it wins over everything the engine ships */
.badge {
  border-radius: 7px;
}
```

### Supported override tokens (public API)

Hosts may override these tokens (unlayered, e.g. `:root { --ra-primary: #663399; }`) and
every derived color — button hover/active states, focus rings, alert tints, table tints,
links — follows automatically:

| Token | Role |
| --- | --- |
| `--ra-primary`, `--ra-secondary`, `--ra-success`, `--ra-info`, `--ra-warning`, `--ra-danger`, `--ra-light`, `--ra-dark` | brand and status colors |
| `--ra-body-bg`, `--ra-body-color` | body surface and text |
| `--ra-link-color` | link color (defaults to a tint of `--ra-primary`) |

A single-color override applies to both light and dark schemes; hosts that want a tuned dark
mode should override with their own pair:

```css
:root {
  --ra-primary: light-dark(#663399, #a97fd6);
}
```

**Every other `--ra-*` name is internal and may change without notice.**

### Dark mode and the `color_scheme` knob

The admin now follows the OS color-scheme preference automatically: every color token is a
`light-dark()` pair, resolved against a `<meta name="color-scheme">` the layout renders from
the new config knob:

```ruby
RailsAdminNext.config do |config|
  config.color_scheme = :auto # default; :light or :dark pins the scheme
end
```

Pin `:light` to keep the old always-light rendering. Two deliberate exceptions: the navbar is
scheme-locked (`navbar_css_classes` express host intent — `navbar-dark bg-primary` stays a
dark navbar under both schemes), and the Trix (ActionText) editor stays light-only for now.

### Token mapping: `--bs-*` → `--ra-*`

The Bootstrap `--bs-*` custom properties are gone. Renamed with the same meaning — read or
override the new name:

| Old | New | Note |
| --- | --- | --- |
| `--bs-body-bg` | `--ra-body-bg` | |
| `--bs-body-color` | `--ra-body-color` | |
| `--bs-body-font-family` | `--ra-body-font-family` | |
| `--bs-body-font-size` | `--ra-body-font-size` | |
| `--bs-body-font-weight` | `--ra-body-font-weight` | |
| `--bs-body-line-height` | `--ra-body-line-height` | |
| `--bs-body-text-align` | `--ra-body-text-align` | still undeclared by default; set it to opt in, exactly like Bootstrap's knob |
| `--bs-breadcrumb-divider` | `--ra-breadcrumb-divider` | |
| `--bs-font-monospace` | `--ra-font-monospace` | |
| `--bs-font-sans-serif` | `--ra-font-sans-serif` | |
| `--bs-gradient` | `--ra-gradient` | |
| `--bs-gutter-x` / `--bs-gutter-y` | `--ra-gutter-x` / `--ra-gutter-y` | grid-scoped |
| `--bs-table-bg` | `--ra-table-bg` | table-scoped; likewise `-accent-bg`, `-striped-bg`, `-striped-color`, `-active-bg`, `-active-color`, `-hover-bg`, `-hover-color` |

Renamed with a value-space change (number → percentage):

| Old | New |
| --- | --- |
| `--bs-bg-opacity: 0.5` | `--ra-bg-opacity: 50%` |
| `--bs-text-opacity: 0.5` | `--ra-text-opacity: 50%` |

Previously declared but consumed by nothing — now live semantic tokens (overriding the
`--bs-*` name never did anything; the `--ra-*` name works): `--bs-primary` →
`--ra-primary`, `--bs-secondary` → `--ra-secondary`, `--bs-success` → `--ra-success`,
`--bs-info` → `--ra-info`, `--bs-warning` → `--ra-warning`, `--bs-danger` → `--ra-danger`,
`--bs-light` → `--ra-light`, `--bs-dark` → `--ra-dark`.

Removed — replaced by derivation (never override these; override the base token instead):
the whole `-rgb` family (`--bs-primary-rgb` … `--bs-dark-rgb`, `--bs-white-rgb`,
`--bs-black-rgb`, `--bs-body-color-rgb`, `--bs-body-bg-rgb`) is gone; utilities now derive
translucency via `color-mix(in srgb, var(--ra-*) <pct>, transparent)`.

Removed without replacement (declared but never consumed): the raw color ladder
(`--bs-blue`, `--bs-indigo`, `--bs-purple`, `--bs-pink`, `--bs-red`, `--bs-orange`,
`--bs-yellow`, `--bs-green`, `--bs-teal`, `--bs-cyan` — the code-pink role of `--bs-pink`
lives on as the internal `--ra-code-color`), `--bs-white`, `--bs-gray`, `--bs-gray-dark`,
`--bs-gray-100` … `--bs-gray-900` (the grays the CSS actually uses exist as internal
`--ra-gray-*` tokens), and `--bs-position` (set by `.dropdown-menu-end` for Bootstrap's
dropdown JS, which this engine does not ship).

### Removed component CSS

The flattened Bootstrap CSS was trimmed to what the engine actually renders. These component
families were deleted as unreachable:

| Removed family | If you relied on it |
| --- | --- |
| Carousel | No engine view renders one; ship your own carousel CSS/JS in custom actions. |
| Tooltip (`.tooltip`, `.bs-tooltip-*`) | Bootstrap tooltips needed Bootstrap JS, which the engine does not ship; use the native `title` attribute or your own library. |
| Popover component (`.popover`, `.bs-popover-*`) | Same as tooltips. (The native `popover` *attribute* is what the engine now uses for its dropdown menus.) |
| Toasts | Engine flash messages render as alerts; `alert-*` stays supported. |
| Offcanvas | Never emitted by engine views. |
| Accordion | Sidebar groups are native `<details>`/`<summary>` now. |
| Spinners (`.spinner-border`, `.spinner-grow`) | The engine's loading indicator is the `#loading` badge. |
| Placeholders (loading skeletons) | Never emitted by engine views. |
| Floating labels (`.form-floating`) | Engine forms use stacked labels. |
| `.form-range` | No engine form renders a range input. |
| Form validation (`.is-valid` / `.is-invalid` / `*-feedback` / `*-tooltip`) | Engine forms render server-side errors through their own `.error` + `.help-inline.text-danger` markup, which is kept. |
| `.form-check` / `.form-switch` wrapper styling | Checkboxes/radios are native, tinted via `accent-color`; `.form-check-input` itself is still styled. |
| jQuery-UI chrome | jQuery-UI is gone. |
| wysihtml5 editor chrome | The editor was dropped; use ActionText/Trix. |
| `.collapsing` | Bootstrap JS's collapse-transition class; sidebar collapse is a native `<details>`. |
| `[data-bs-popper]` rules | Popper.js is not shipped. |
| `.dropup` / `.dropend` / `.dropstart` | Engine menus only drop down (and flip above the toggle automatically near the viewport edge). |
| Responsive tiers `sm` / `lg` / `xl` / `xxl` | The `.col-sm-*` grid columns engine forms emit survive; the responsive display/spacing/text utilities and `container-*` tiers are gone (a couple of `md` utilities remain). |
| Print utilities (`.d-print-*`) | Gone; add your own print CSS if you print admin pages. |

### The styled vocabulary (keep-list)

The stylesheet keeps a deliberate keep-list even where no engine view currently emits the
class: vocabularies that are host-facing configuration API remain styled and supported —

- `.navbar-light` / `.navbar-dark` — the `navbar_css_classes` value space,
- `alert-*` — the `flash_alert_class` value space,
- `bg-*` utilities — badges, indicators, and the host navbar,
- `.badge` colors,
- `table-*` contextual rows — `row_css_class` conventions.

Class names the stylesheet does not style are out of contract and may stay unstyled.

## Markup changes

Three widgets moved from Bootstrap markup to native platform primitives. Hand-rolled host CSS
or JS that targeted the old DOM needs updating — `.modal.fade`, `.dropdown .show`, and the
sidebar's `.collapse` no longer appear:

| Widget | Was | Now |
| --- | --- | --- |
| Inline-edit modal | `.modal.fade` + `.modal-dialog` divs | native `<dialog id="modal" closedby="any">` |
| Dropdown menus (filters, bulk actions) | `<a role="button">` toggles + `.dropdown .show` | `<button popovertarget>` toggles + `popover="auto"` menus, positioned with CSS anchor positioning |
| Sidebar navigation groups | `.collapse` + Bootstrap collapse classes | native `<details>`/`<summary>` disclosures |

## Required `belongs_to` associations

A `belongs_to` your model actually requires is now rendered as required. Previously only a
presence or numericality validator on the association or its foreign key was detected, and
Rails registers the validator it adds for a required `belongs_to` with an `if:` condition that
the detection skipped.

`belongs_to_required_by_default` has been on since `load_defaults 5.0`. On `load_defaults 7.1`
or later Rails also sets `belongs_to_required_validates_foreign_key = false`, which is what makes
the presence validator conditional and invisible to the old detection — so this affects every
plain `belongs_to` whose foreign key carries no validator of its own. For those fields:

- the help text reads "Required." instead of "Optional."
- a plain association select carries `required`, so the browser blocks submission while it is
  empty; polymorphic association fields change help text and filter operators only, because
  their partial does not apply the field's HTML attributes
- the association select no longer offers its clear-selection entry
- the index filter loses the "is present" and "is blank" operators

An association declared with `default:` is left optional, since Rails fills it in a
`before_validation` callback. If a model fills the association server-side some other way, the
browser will now block a form the server would have accepted. Mark the field optional:

```ruby
RailsAdminNext.config Order do
  edit do
    field :customer do
      optional true
    end
  end
end
```

## Nested forms hide the link back to the parent

A nested subform no longer renders the child's association back to the record being edited.
Editing a `FieldTest` with `has_one :comment, as: :commentable` used to ask, from inside that
form, which record the comment belonged to — a choice the parent had already made and that the
nested save overwrote anyway.

This widened along with the association's notion of an inverse. `inverse_of` now answers with
the declared `inverse_of:`, otherwise the inverse ActiveRecord resolves for the reflection,
otherwise a polymorphic `as:`. It previously answered only the declared option, so a pair that
declared nothing on either side — the conventional case Rails resolves on its own — reported no
inverse and the back-reference stayed on screen. Combined with required `belongs_to` detection
above, that field could be marked required while being one only the nested save can fill.

Two consequences worth checking in a host app:

- A subform for a pair that relies on Rails' automatic inverse detection now hides one more
  field than before, and its key is no longer permitted inside `<assoc>_attributes[...]` either.
  Only at nested depth: editing the child on its own still permits its own association, which is
  a legitimate way to set it.
- `field.inverse_of` in your own configuration blocks now returns a symbol for associations
  that previously returned `nil`.

**Narrowing the allowlist is a security fix, for collections.** Saving a singular association re-applies
the owner to the child, so a submitted back-reference never survived there. A collection does not:
`assign_nested_attributes_for_collection_association` assigns straight onto an already-associated
record, so a crafted back-reference inside `<assoc>_attributes[n]` moved that child onto a
different parent — one the submitter may have had no rights over. Dropping the key from the
allowlist closes it, because it never reaches the assignment.

`inverse_of: false` on the association is honoured, as in Rails. To keep the back-reference
visible — and permitted — for one field without touching the model, disable the parent field's
inverse. On a collection that re-opens the re-parenting described above, so scope it to the one
field that needs it:

```ruby
RailsAdminNext.config FieldTest do
  edit do
    field :comment do
      inverse_of { false }
    end
  end
end
```

Note the block: a bare `inverse_of nil` reads the option rather than setting it.

## Nested forms that can reach themselves stop at three levels

A nested form for an association that leads back to its own model, such as a self-referential
`has_many :children` with `accepts_nested_attributes_for`, used to render without end and fail
with `SystemStackError`, as did saved records that point back at each other. It now nests the
same association at most three times along one chain; past that, the association's rows, blank
template and add control are left out of the form, so a deeper tree is edited from a lower
record. Chains of distinct associations are not capped.

The blank row's child-index placeholder is tagged by depth, `new_<depth>_<association>` (for
example `new_1_comments`), rather than `new_<association>`. Host JavaScript that looked for the
old token in a nested form's `<template>` needs the new one.

## The show action answers HTML by default

`show` used to declare its JSON format before its HTML one, so a request carrying no
`Accept` header — `curl`, a bare `fetch()`, most HTTP client libraries — arrived as
`*/*`, matched every registered type, and got JSON back. Every other action answered
HTML for the same request.

It now declares HTML first. A client that explicitly sends `Accept: application/json`,
or requests the `.json` extension, is unaffected.

If you have a script relying on the unheadered JSON response, send the header or use
`.json`:

```bash
curl -H 'Accept: application/json' https://example.com/admin/player/1
curl https://example.com/admin/player/1.json
```

The JSON branch renders only the fields the show view displays (see below).

## JSON and XML serialize only configured fields

The index action's `.json`/`.xml`, the show action's `.json`, and the export action's JSON/XML
used to serialize every attribute of the record, and export passed the submitted `schema` straight
to `to_json`/`to_xml` — so any `methods` or `include` name in it was called on every record.

They now serialize only what the matching section shows: `list` for index, `show` for show,
`export` for export. Index and show also keep the foreign keys of the `belongs_to` associations
they display. A submitted export `schema` is intersected with the export fields, and `except` is
ignored.

If a client relied on a column the section doesn't show, add that field to the section.

## Malformed filter params are ignored

The index page used to answer a hand-written or stale `f[...]` query string with a 500: a
filter that wasn't the `field => index => {o:, v:}` shape the filter box submits, one naming
a field that isn't filterable (`is not currently filterable`), or a value the field couldn't
parse, such as an impossible date or malformed JSON. Such a filter is now dropped and the
rest of the list renders. A value that fails to parse counts as no value, so a bookmarked
link to a field that has since stopped being filterable lists every record rather than
erroring.

## Pundit: a model with no policy Scope lists nothing

A model whose policy defines no `Scope` used to list every record. It now lists none: the
list, export, bulk delete and dashboard count all return an empty set, so "no Scope" can't
mean "everything".

This holds only when no `Scope` constant resolves. A policy that subclasses `ApplicationPolicy`
without its own `Scope` inherits `ApplicationPolicy::Scope`: Pundit's generated `resolve` there
raises `NoMethodError`, and one that returns `scope.all` lists every record.

Define a `Scope` for each model the admin exposes:

```ruby
class PlayerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
```

## ActionPolicy adapter

[ActionPolicy](https://github.com/palkan/action_policy) is a built-in adapter next to Pundit.
Bundle `action_policy` in your app, then:

```ruby
RailsAdminNext.config do |config|
  config.authorize_with :action_policy
  config.current_user_method(&:current_user)
end
```

The adapter authorizes as the user `current_user_method` returns. It checks the record's
policy with the rule names the Pundit adapter uses: `dashboard?`, `index?`, `show?`, `new?`,
`edit?`, `export?`, `destroy?`, `history?`, `show_in_app?`, plus `create?` and `update?` when a
form is submitted, and `<authorization_key>?` for custom actions. Two ActionPolicy defaults
change how a ported Pundit policy behaves:

- `new?` is an alias of `create?` unless the policy defines `new?` itself.
- A rule the policy does not define resolves to `manage?`, which is `false` on
  `ActionPolicy::Base`, instead of raising. That includes a mistyped `authorization_key`,
  so a policy whose `manage?` is true lets that action through.

A model with no policy of its own or a parent model's, and the dashboard, are checked against
`ApplicationPolicy`. Lists,
export, bulk delete and dashboard counts use the policy's default `relation_scope`; a model
with no policy, no relation scope, or only named ones lists nothing. To prefill new records,
define `attributes_for(action)` on the policy, as with Pundit.

```ruby
class ApplicationPolicy < ActionPolicy::Base
  def dashboard? = user.admin?
  def index? = user.admin?
  def show? = user.admin?
  def create? = user.admin?
  def update? = user.admin?
  alias_rule :edit?, to: :update?
  def destroy? = user.admin?
  def export? = user.admin?
end

class PlayerPolicy < ApplicationPolicy
  relation_scope { |relation| relation }
end
```

### Authorization context beyond the user

A policy that declares more context than `user`, such as a tenant's `authorize :account`,
needs the adapter to supply it. Pass each key as a block:

```ruby
RailsAdminNext.config do |config|
  config.authorize_with :action_policy, context: {account: -> { _current_user.account }}
end
```

Each block runs on the admin controller once per request, the first time anything is
authorized, whichever policy is checked; a block should return `nil` rather than raise for a
user with no such context. A helper from your own controller, such as `current_account`, is
only available there when `config.parent_controller` names that controller:

```ruby
config.parent_controller = "::ApplicationController"
config.authorize_with :action_policy, context: {account: -> { current_account }}
```

The value is an authorization input, so derive it from the signed-in user, or check the user's
membership when it comes from request data such as `params` or the subdomain. The relation scope
only narrows lists, export and bulk actions: show, edit, delete and history load the record by
id and check the rule alone, so a tenant rule such as `update?` must compare `record` with
`account` itself.

`user` always comes from `current_user_method` and is rejected inside `context:`. A key that is
not a Symbol, a value that is not a block taking no arguments, or an unknown option raises
`ArgumentError` while the config block runs. A key a policy declares that the host omits, or
whose block returns `nil`, raises `ActionPolicy::AuthorizationContextMissing` on the request
unless the policy declares it with `allow_nil:` or `optional:`.

## An `:enum` field with no option source offers no options

An `:enum` field takes its options from `enum_method`, which defaults to `<name>_enum` on the
model class or the record. When neither defines it, the field used to call `<name>` itself and
treat the record's current value as the option list: the index filter crashed, and the form
offered that value instead of choices. It now offers no options.

If a field's own method returns its option list, name it explicitly:

```ruby
field :colors, :enum do
  enum_method :colors
end
```

## A redeclared field keeps its `visible` block

Declaring a field again in the same section used to discard a `visible { ... }` block set by an
earlier declaration and show the field to everyone. The block now survives:

```ruby
field :salary do
  visible { bindings[:view].current_user.admin? }
end
field :salary # still hidden from non-admins
```

If a field you hide conditionally started showing for everyone after a later `field` call, it is
hidden again. A field hidden with a plain `visible false` is still shown again by a later
declaration, as before.

## Serialized fields load only plain YAML

A `serialized` field (the default for a `store` or `serialize` attribute) now shows its value
as plain YAML, without `!ruby/...` class tags, and loads the submitted YAML with only `Symbol`,
`Date` and `Time` permitted. A store's `HashWithIndifferentAccess` comes back as a plain `Hash`,
which the store wraps again on assignment. YAML naming any other class is rejected.

The `safe_yaml` gem is no longer consulted, even when the host bundles it.
`RailsAdminNext.yaml_load` and `RailsAdminNext.yaml_dump` are deprecated: call
`YAML.safe_load` and `YAML.dump` directly.

## `config.model "::Order"` configures `Order`

A model named as a string or symbol with a leading `::` used to register a second, separate
entry: its block never reached `Order`, and `Order` appeared twice in the navigation. The `::`
is now dropped, so the block applies to `Order`. If such a block was silently doing nothing,
check that what it configures is what you want before upgrading. `included_models` and
`excluded_models` drop a leading `::` the same way.

## Scope tabs apply to export and bulk delete

The tab selected on a list (`list { scopes [...] }`) now also narrows export and bulk
delete: "Export found" streams only the tab's records, and bulk delete lists and destroys
only the tab's records, whatever ids are submitted. The bulk form and the confirmation
form carry `scope` so the tab survives the round trip.

A tabbed collection stays inside the authorization scope, so a tab that drops conditions,
such as `unscoped`, cannot list, export or delete records the user may not see. It still
drops the model's own configured `scope`. The authorization scope is built on the model's
`default_scope`, so an `unscoped` tab no longer reaches records `default_scope` hides: a
soft-delete "trash" tab built on `unscoped` comes up empty. Give such a tab a scope the
authorization relation also reaches.

The `scopes` block is now evaluated with `bindings[:controller]`, `bindings[:view]` and
`bindings[:object]`, so tabs can depend on the current user:

```ruby
config.model "Order" do
  list do
    scopes { bindings[:controller].current_user.admin? ? [nil, :refunded] : [nil] }
  end
end
```

`list_entries` keeps its four positional arguments, but applies a tab only for the page's
own model, its `additional_scope` defaults to `nil`, and it no longer reads the
`associated_collection` picker params. Custom actions that listed picker records through
it should call `association_entries(model_config, collection_scope)` instead.

## Bulk delete checks `destroy?` on each record

Bulk delete now asks the policy's `destroy?` (or the rule named by the action's
`authorization_key`) of every selected record, as the single delete does, with both Pundit
and ActionPolicy. A record it refuses is left out of the confirmation
page, is not destroyed, and counts in the "failed to be deleted" message. Before, bulk
delete honoured only the scope, so a `destroy?` rule that reads the record, such as
`!record.locked?`, stopped the single delete but not the bulk one.

## Export includes an association only if its model may be listed

With Pundit or ActionPolicy configured, export leaves out an association unless the policy grants
`index?` on the associated model (or the rule named by the index action's `authorization_key`) and
the index action is enabled for it.
The export form stops offering its fields, and a submitted `schema[include]` naming it is dropped,
for CSV, JSON and XML alike. Before, the user needed only `export?` on the exported model, so a
user who could export players but not list teams still got each player's team columns. With no
authorization adapter nothing changes.

An included association also exports only the records the associated model's policy scope (Pundit
`Scope`, ActionPolicy `relation_scope`) lets the user list. A linked record outside that scope
exports as an empty cell in CSV and is left out of JSON and XML, as if the row had no such record.
An associated model whose policy defines no scope exports none of its records, as its list shows
none. Each batch of exported rows narrows an included association with one more query, whatever its
shape, through associations included. The list and show pages still show associated records by
their label without this scope.

A method on the exported model that reads an included association sees the narrowed records, so
one that dereferences a hidden `belongs_to` gets `nil`. A virtual field of the exported model is its
own field: one that reads an association in full exports what it reads, whatever the associated
model's scope.

## `associated_collection_scope` runs after the list sort

Association pickers apply `associated_collection_scope` after the picked model's list sort,
so a `reorder` in it now decides the order. A plain `order` adds a secondary sort key after
the list sort. Build on the relation the proc receives: returning a fresh relation discards
the authorization scope, the picker's search query, sort and eager loads as well. Pickers
never apply the picked model's scope tabs.

## CSV export follows the list sort

CSV export used to walk records with `find_each`, which discards the list sort, so every file
came out in primary-key ascending order. It now writes rows in the order the list shows them:
the sort the export request carries, or the list's default sort. For most models that default is
the primary key descending, so an export with no sort chosen is now newest first.

Rows are read in batches of 1000 instead of loading every record up front. An export with no
matching records now contains the header row instead of an empty line.

## Admin pages show a footer

Every admin page now ends with a small, muted "Made in Tokyo with ❤️ and 🤖" line under the page
content. It is not shown inside modals. To hide it, set `config.show_footer = false` in your
initializer.

## STI subclasses use their parent model's policy

Both the Pundit and the ActionPolicy adapter used to check an STI subclass with no policy of its
own against `ApplicationPolicy`, and to list none of its records. Such a subclass now takes the
nearest parent model's policy, for its rules and its scope alike, before `ApplicationPolicy`:
a `Hardball < Ball` with no `HardballPolicy` uses `BallPolicy`. A subclass that defines its own
policy still uses it, and lists nothing if that policy has no scope.

If `ApplicationPolicy` granted a subclass what its parent's policy denies, it is now denied. If
`ApplicationPolicy` denied a subclass what its parent's policy grants, it is now granted, and the
subclass lists what the parent's scope returns. Either way, give the subclass its own policy to
keep the old access.

The walk follows Ruby class inheritance, not the `type` column: a concrete subclass of a model
takes that model's policy even when it is not STI.

The Pundit adapter builds the parent's policy as `PolicyClass.new(pundit_user, record)` and its
scope as `PolicyClass::Scope.new(pundit_user, scope)`, Pundit's standard constructors. If your
policy classes take different arguments, a subclass that falls back to its parent's policy raises
instead. The navigation checks every visible model, so every admin page then shows an error:
access is denied, never granted. Define that subclass's own policy to avoid the fallback.

## A scope that is not a relation lists nothing

A policy scope that returned `nil` (a Pundit `Scope#resolve` or an ActionPolicy `relation_scope`
with a branch that falls through, such as `scope.all if user.admin?`) used to remove the
restriction, so the list, export, bulk actions, association pickers and dashboard counts showed
every record. A `Hash` or a `Proc` did the same, and an `Array` (`scope.to_a`) raised. With an
authorization adapter configured, a scope that is not an `ActiveRecord::Relation` now lists
nothing, whichever adapter returned it, custom adapters included. That includes the model class
itself: return `scope.all` or `Model.all`, not `Model`. Return a relation from every branch of the
scope. Without an authorization adapter nothing changes.

## Association pickers check the source record

An association picker's list can be shaped by the record whose form it sits on: an
`associated_collection_scope` block reads it as `bindings[:object]`. The picker now binds that
record only when it can be loaded through the source model's `scope`, and, with an authorization
adapter configured, only when the adapter allows the edit action on it (`edit?` unless the
action's `authorization_key` is changed; ActionPolicy aliases `edit?` to `update?`, Pundit does
not). A host with an adapter but no `edit` action binds no record.

Otherwise the picker skips the field's `associated_collection_scope` and lists the picked model's
index, as it does for any picker request it rejects. A source id that does not exist gets the same
list, so the response does not reveal which ids exist. A new record's form names no source and
still runs `associated_collection_scope` with a `nil` record.

Hosts without an adapter see two changes: a source record outside the model's `scope` is no longer
bound, and a source id that does not exist now lists the index instead of running
`associated_collection_scope` with a `nil` record.

Inside a nested form the record is the nested one. Its pickers now also send the persisted records
it is nested under. The record counts as editable when the adapter allows editing a parent and the
record belongs to a nested-form association that parent's form shows and lets the user edit: the
`update` section of the parent the user edits, and the `nested` section of any parent in between,
counting only fields in visible groups and no deeper than the form renders. A model edited only
through its parent's form no longer needs an `edit?` policy of its own. That check runs the
parent's `visible` blocks with `bindings[:controller]`, `bindings[:view]` and `bindings[:object]`
set, but no `bindings[:form]`.

## Removed: options deprecated before RailsAdmin 3.0

These six were deprecated upstream between 2019-07 and 2022-01 and had no effect for
years. They are gone rather than carried into this gem's 1.0:

| Removed | What to do |
| --- | --- |
| `config.total_columns_width=` | Nothing. It had no effect. |
| `config.sidescroll=` | Nothing. Horizontal scroll with frozen columns is always on. |
| `list.sidescroll` | Nothing. Same as above. The field-level `sticky?` still controls which columns freeze. |
| `list.sort_reverse` | Nothing. It had no effect. The field-level `sort_reverse?` is unrelated and unaffected. |
| `momentjs_format` | Nothing. Date/time fields are native HTML5 inputs and render per the browser locale. |
| `eager_load?` | Rename to `eager_load`. |
| `delete_key` (`:multiple_file_upload`) | Rename to `delete_value`. |

`register_deprecated_instance_option` itself stays — extensions and host apps use it for
their own options.

## Dropped support

These are intentionally gone — migrate off them before upgrading:

- **Mongoid** — RailsAdminNext is ActiveRecord only.
- **Sprockets / Webpacker / Webpack / Vite** — importmap + Propshaft only.
- **Standalone WYSIWYG/code editor field types** (`bootstrap-wysihtml5`, `froala`, and the
  cdnjs-backed `:ck_editor` / `:code_mirror` / `:simple_mde`) — they loaded JS/CSS from cdnjs.
  Migrate those fields to `:action_text` (self-hosted Trix rich text) or a plain `:text` textarea
  instead. The engine now has **zero external CDN** usage, default and opt-in.
- **Non-ActiveStorage attachment libraries** (CarrierWave, Paperclip, Shrine, Dragonfly,
  Refile) — RailsAdminNext detects **ActiveStorage** (and ActionText/Trix) attachments only.
  Migrate file/image columns to ActiveStorage before upgrading. Image variants are processed
  with **libvips** via `image_processing` + `ruby-vips` (set
  `config.active_storage.variant_processor = :vips`); install the libvips system library
  (`brew install vips` / `apt-get install libvips-dev`) — ImageMagick is no longer required.
- **Configurable app branding (`main_app_name`)** — the navbar brand and page `<title>` are
  hardcoded to "Rails AdminNext"; the config option is gone. Fork
  `app/views/layouts/rails_admin_next/_navigation.html.erb` and `content.html.erb` in your
  host app if you need custom branding.

## History / audit table

The gem owns **no** history table. Auditing remains host/PaperTrail territory, so there is
no gem migration to run — your existing `rails_admin_histories` table (if any) is unaffected.

A record's history page now honours its column sort, and with no sort it lists newest
first, like the model history page. It used to list a record's versions oldest first
whatever the sort.

## History and "last created" stay inside the authorization scope

With an authorization adapter configured, the dashboard and the history pages now show only
what the user may list:

- The dashboard's history feed shows changes only to records of models the user may `index`,
  and only to records inside that model's authorization scope (the scope `query(:index, ...)`
  returns).
- A model's history page (`history_index`) shows changes only to records inside the scope
  `query(:history, ...)` returns.
- A model's "Last created" time on the dashboard reads the newest record inside the scope.

Changes to a deleted record are no longer shown under an authorization adapter, since no live
record places them inside a scope. A record's own history page (`history_show`) is unchanged:
it is authorized against the record itself. Without an authorization adapter, nothing changes.

A custom auditing adapter must accept the new keyword arguments when an authorization adapter is
configured: `latest(count, scopes:)`, where `scopes` maps each `AbstractModel` the user may list
to its authorized relation, and `listing_for_model(..., scope:)`, the model's authorized relation.
Restrict versions to items inside those relations. An adapter that does not accept them raises
`ArgumentError` instead of listing unscoped history.

A `last_created_at` override in model config is not scoped for you. It runs with
`bindings[:controller]`, so it can read
`bindings[:controller].authorization_scope(:index, abstract_model)`: the authorized relation, an
empty one when the policy scope is broken, or `nil` without an authorization adapter. Calling the
adapter's `query` directly skips that check.

## History is hidden for a model PaperTrail does not version

With `config.audit_with :paper_trail`, a model without `has_paper_trail` no longer shows History
links, and its history pages list no versions. They used to fail with `NoMethodError`.

An auditing adapter may define `auditable?(abstract_model)`. When it answers false, the
`history_index` and `history_show` actions are hidden for that model. A custom adapter that does
not define it keeps the History links on every model, as before. A `visible` block you configure
on either history action replaces this check.
