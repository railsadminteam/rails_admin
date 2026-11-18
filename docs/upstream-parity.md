# Upstream parity

Assessed through upstream `2dfd05f1` (2026-10-30). Fork point: `d8e0809e` (2025-09-14).

Divergence from the fork point: 792 files, +21,203 / −73,569 lines.

## How this fork tracks upstream

RailsAdminNext is a hard fork of [railsadminteam/rails_admin](https://github.com/railsadminteam/rails_admin). It is **never merged or rebased from upstream**, and it cannot be: the fork deleted whole subsystems upstream still ships — the Mongoid adapter, the npm/webpack build, jQuery and `@rails/ujs`, Bootstrap's JavaScript, Appraisal, CarrierWave. Replaying this fork's history onto a moving upstream would conflict with every commit touching any of them, by construction.

Instead, upstream work is absorbed by **reimplementation**: read the upstream commit, judge whether the underlying problem exists here, and write the fix in this codebase's terms. A port therefore need not — and often should not — match upstream's diff. Deliberate divergences are recorded below so they are not "corrected" back later.

This means `git rev-list --count upstream/master...master` is not a progress measure. It counts commits never merged, so it does not fall when work is absorbed and it grows every time upstream moves. **This ledger is the state.** The watermark above records what has been assessed; the table records the verdict for each commit, including the ones deliberately skipped.

## Verdicts

Commits are listed newest first, as `git log` reports them.

| upstream | subject | verdict | ours |
|---|---|---|---|
| `2dfd05f1` | Test ferrum 0.19.2 with flatten mode on JRuby | n/a — JRuby leg over Appraisal gemfiles; neither exists here | — |
| `bf8f645c` | Replace nested_form with RailsAdmin's own nested form implementation | partly relevant — per-controller `<template>` and button controls already here; unsaved-row remove, self-reference recursion, placeholder collision and the dummy belongs_to still apply | [#73](https://github.com/6temes/rails_admin_next/issues/73) |
| `6e27f4d3` | Let the adapter narrow a scope, instead of merging it here | n/a — one AR adapter; the controller's merge is already its vocabulary, no behaviour change | — |
| `20f8f29a` | Narrow a listing by the scope it selects before it is paginated | partly adapted — pre-pagination done; export and bulk delete ignore the tab, and remote pickers get it | [#60](https://github.com/6temes/rails_admin_next/issues/60) |
| `7e5a7d67` | Keep the browser driver off a version the suite hangs on | partly relevant — the pin is JRuby-only (n/a); the missing job timeout matches this fork's apt-step hangs | [#74](https://github.com/6temes/rails_admin_next/issues/74) |
| `1e0bd4fd` | Say what an upload needs from an embedded document | n/a — embedded documents are Mongoid; no upload docs here | — |
| `6651f64d` | Say which records associated_collection_scope governs | n/a — the option isn't documented here, so nothing to correct | — |
| `51d7321a` | Look up a registered visible block by the option's own name | relevant — measured: redeclaring a field drops its visible block; `admin?` raises NameError | [#64](https://github.com/6temes/rails_admin_next/issues/64) |
| `e67edd00` | Escape a field name before it stands in for a selector | n/a — the filter container is found by `getElementById`; other selectors use `CSS.escape` or quoted values | — |
| `11cd3e53` | Leave out a column the queried term could never fit | relevant — measured: PG raises NumericValueOutOfRange for a 10-digit term on int4 | [#56](https://github.com/6temes/rails_admin_next/issues/56) |
| `2d9f951f` | Have no enumeration rather than crash when there's no _enum method | relevant — measured: enum without a source crashes filter_operators; native PG enums hit it unconfigured | [#58](https://github.com/6temes/rails_admin_next/issues/58) |
| `c4b64ede` | Document sort_by's array and hash forms | n/a — sort_by isn't documented here; the forms are supported | — |
| `cbed4c42` | Fall back to the guessed encoding when a CSV export leaves it blank | n/a — measured: blank does what the form says here (leaves encoding untouched); the fallback is a no-op on the connection encoding | — |
| `8748af05` | Bind the controller and view before reading a model's list scopes | relevant — measured: both reads are unbound | [#62](https://github.com/6temes/rails_admin_next/issues/62) |
| `3e26f685` | Keep a serialized value's wrapper class out of the text an admin edits | relevant — measured: every AR `store` round-trip raises DisallowedClass | [#63](https://github.com/6temes/rails_admin_next/issues/63) |
| `8b7f686b` | Let a requested sort win over has_paper_trail's own version order | relevant — `order` appended after paper_trail's association order | [#69](https://github.com/6temes/rails_admin_next/issues/69) |
| `e9e13ebf` | Recognize a native timestamptz column as a timestamp field | relevant — measured: Rails 8.1.4 PG reports `:timestamptz`, which the registry rejects | [#55](https://github.com/6temes/rails_admin_next/issues/55) |
| `0c6b8e9d` | Version 4.0.0.beta2 | n/a — upstream release chore | — |
| `d96845da` | [Security] Fail closed when Pundit policy scope is undefined | relevant — the adapter rescued a missing Scope with `model.all`; fixed with plain AR `none` (no repository indirection needed) | [#77](https://github.com/6temes/rails_admin_next/pull/77) |
| `a6cf6bb0` | [Security] Limit JSON/XML serialization to the configured fields | partly adapted — the GET gate was already here; methods/hidden columns via `schema` and full-row index/show output fixed; the default never calls virtual fields | [#77](https://github.com/6temes/rails_admin_next/pull/77) |
| `fca081f2` | Version 4.0.0.beta | n/a — upstream release chore | — |
| `00ddcd06` | Drop the dummy app's tooling for asset modes that no longer exist | n/a — none of those files are tracked here | — |
| `d593bcaf` | Serve the dummy app's own JavaScript through every asset pipeline | n/a — one pipeline; the host entry is an ESM module importing Turbo | — |
| `72bdd18d` | Let any callable serve as asset_source | n/a — `asset_source=` is a deprecated no-op here | — |
| `812109cf` | Put the :external stylesheet where a JS build will not eat it | n/a — the installer writes only an initializer | — |
| `9ed33f69` | Keep the dummy app's test hooks out of development | n/a — the only test hook here is invisible | — |
| `7cc5e292` | Keep the dummy app's cookies readable, and cover CSRF both ways | partly relevant — the json pin is moot on Rails 8.1.4; the CSRF acceptance coverage gap applies | [#76](https://github.com/6temes/rails_admin_next/issues/76) |
| `fd0bf316` | Drop the docs left behind by the asset rework | n/a — docs here mention those pipelines only as removed | — |
| `3af6946c` | Flush rich-text editors before the modal submits | n/a — Trix writes its input on every change; no submit-time editor remains | — |
| `a16b425f` | Test carrierwave 3.x and 4.x within the existing CI matrix | n/a — CarrierWave removed | — |
| `8302cc29` | Lower a search term with String#downcase | adapted — already `downcase`; no `mb_chars` left | — |
| `63ebb9ac` | Ask whether an enum is null, not whether it equals '' | relevant — measured: PG rejects `= ''` on an integer enum | [#57](https://github.com/6temes/rails_admin_next/issues/57) |
| `749cbe75` | Let associated_collection_scope decide the order it asks for | relevant — scope applied before the reorder; the swap must follow #60 | [#61](https://github.com/6temes/rails_admin_next/issues/61) |
| `47da8e99` | Refresh SimpleMDE editors when their tab is shown | n/a — no layout-measuring editor ships here | — |
| `4443ab35` | Ship a prebuilt asset bundle; collapse config.asset_source | n/a — already a single zero-build importmap + Propshaft path | — |
| `478484fb` | CI: install ImageMagick against a refreshed package list | n/a — the step here already runs `apt-get update` and `-y`; the failure here is a stall (#74) | — |
| `a6f4c5ad` | Fix the viewport meta tag's name attribute | relevant — the identical malformed tag is in `_head.html.erb` | [#72](https://github.com/6temes/rails_admin_next/issues/72) |
| `88e6df4d` | Strip a leading :: when deriving a model's config registry key | relevant — measured: config ignored and the model listed twice | [#70](https://github.com/6temes/rails_admin_next/issues/70) |
| `a5607f24` | Use label_plural in bulk delete flash messages | relevant — measured: translated plural ignored | [#71](https://github.com/6temes/rails_admin_next/issues/71) |
| `7b60193b` | Let the page catch up before reading the database | adapted — fixed independently here | [#23](https://github.com/6temes/rails_admin_next/pull/23) |
| `ef3e3f57` | Keep one dead browser from failing the examples after it | partly relevant — the driver restore applies; the startup-timeout half is deferred (never seen in ~60 runs) | [#75](https://github.com/6temes/rails_admin_next/issues/75) |
| `cc293dea` | Wait for the autocomplete menu itself, not for one of its entries | n/a — waits here use counts or text the stale menu can't satisfy; the widget renders once per query (as `77e5d0bc`) | — |
| `d3cfba1d` | Render the list for a filter URL written by hand | relevant — measured: seven malformed shapes 500, one specific to this fork | [#65](https://github.com/6temes/rails_admin_next/issues/65) |
| `ede4e77b` | Split the adapter layer into a Reflection and a Repository | declined — multi-ORM refactor, one adapter here; four embedded fixes filed separately | [#59](https://github.com/6temes/rails_admin_next/issues/59), [#66](https://github.com/6temes/rails_admin_next/issues/66), [#67](https://github.com/6temes/rails_admin_next/issues/67), [#68](https://github.com/6temes/rails_admin_next/issues/68) |
| `897ffc13` | Fix _discard leaking into SQL for multi-select enum filters | adapted — server half only; the client half was already stronger here (disabled options), so upstream's JS was deliberately not ported | [#36](https://github.com/6temes/rails_admin_next/pull/36) |
| `11f214f6` | Remove config options deprecated before RailsAdmin 3.0 | adapted — the deprecator half already shipped; this removed the six options | [#40](https://github.com/6temes/rails_admin_next/pull/40) |
| `cbea80b1` | Match GET in http_methods case-insensitively | adapted — `Actions::Base#linkable?` | [#38](https://github.com/6temes/rails_admin_next/pull/38) |
| `9336ec71` | Drop Proc bounds from a field's length validation | adapted — widened beyond upstream to Symbol bounds, which crash identically | [#35](https://github.com/6temes/rails_admin_next/pull/35) |
| `331841ea` | Remove duplicate global assignment of window.jQuery | n/a — jQuery removed | — |
| `71852cd8` | Fix malformed rubocop directive comment | n/a — measured: standardrb clean, and no `has_option?` directive here to malform | — |
| `cfc17e0d` | Pin json to < 3 for the test suite | n/a — dependency churn, Dependabot's job | — |
| `316c299d` | Change default response format of the show action to HTML | adapted | [#39](https://github.com/6temes/rails_admin_next/pull/39) |
| `0f4f765e` | Use the same widget which works for nullable booleans also for non nullable | declined — cosmetic consistency change; alters every boolean field in every host app and fixes no defect | — |
| `495cc864` | Filter ferrum 0.18's console stack-frame log lines | adapted — landed before the cuprite bump that would trigger it | [#37](https://github.com/6temes/rails_admin_next/pull/37) |
| `2eed28e1` | Fully specify all ESM imports with an extension | n/a — measured: every relative import in `src/` already carries `.js`; browser-native ESM requires it | — |
| `e8dec57a` | Upgrade @hotwired/turbo-rails to resolve security warning | n/a — turbo comes from the `turbo-rails` gem (2.0.23), which Dependabot reads | — |
| `07b2066a` | Replace `asset-url` with `url` in Sass files | n/a — no Sass; one hand-owned CSS file | — |
| `a0946615` | Drop support for Rails 6.x and Ruby 2.5/2.6 | n/a — this fork is Rails ~> 8.1 / Ruby >= 4.0 only | — |
| `0543cb3f` | Revert npm package.json version ahead of actual publish | n/a — no npm package | — |
| `cf7b112e` | Run Prettier on migrated docs | n/a — upstream's vendored wiki | — |
| `1c2b92a3` | Rewrite wiki cross-links to relative docs/ links | n/a — upstream's vendored wiki | — |
| `70ca765e` | Merge wiki history into docs/ | n/a — upstream vendored its GitHub wiki; this fork ships its own docs | — |
| `0690a5e6` | Start development for 4.0.0 | n/a — upstream release chore | — |
| `50fbbcd9` | Remove @babel/runtime as a direct dependency | n/a — no npm build here | — |
| `e4ad87b7` | Replace deprecated jQuery functions with native ones | n/a — jQuery removed | — |
| `77e5d0bc` | Improve intermittent autocomplete test failures due to stale element | n/a — measured: the widget stamps and aborts its own requests, and each query renders once | [#18](https://github.com/6temes/rails_admin_next/issues/18) |
| `26bb8763` | Declare JavaScript package is a module | n/a — no npm package | — |
| `336845f4` | Remove string mutation | adapted | [#16](https://github.com/6temes/rails_admin_next/pull/16) |
| `b72badeb` | Add a "sass" entry point to package.json | n/a — no npm/webpack build | — |
| `9b21e3ba` | Update rails/ujs NPM package | n/a — UJS removed, Turbo replaces it | — |
| `ca2d0954` | Use a non-beta trix package in dummy_app | n/a — trix is self-hosted from `action_text-trix`, not an npm pin | — |
| `1f681b48` | Add nonce to css/js tags | adapted — `csp_meta_tag` deliberately left out, see below | [#22](https://github.com/6temes/rails_admin_next/pull/22) |
| `54a23401` | Add belongs_to optional/required support to `required?` | adapted | [#13](https://github.com/6temes/rails_admin_next/pull/13) |
| `c18592a1` | Draw routes before the suite goes multi-threaded | adapted — premise corrected, see PR | [#17](https://github.com/6temes/rails_admin_next/pull/17) |
| `91e9cca8` | Resolve the inverse of a polymorphic association | adapted — 3 divergences, see below | [#14](https://github.com/6temes/rails_admin_next/pull/14) |
| `8bffeb61` | Pin vite-plugin-ruby below 5.2 | n/a — no vite | — |
| `9f03412d` | Fix RuboCop offense in main_controller_spec | n/a — linting is Standard Ruby | — |
| `17b64251` | Avoid carrierwave versions that pull in mimemagic | n/a — CarrierWave removed | — |
| `703e4894` | Add Rails 8.1 support | n/a — this fork is Rails ~> 8.1 only | — |
| `9881e254` | Add test for editing a nested one widget item | adapted — driven through this fork's markup | [#15](https://github.com/6temes/rails_admin_next/pull/15) |
| `47d913fe` | Fix flaky locale spec for Datetimepicker widget | n/a — native HTML5 date/time inputs replaced the widget | — |
| `ec685453` | Don't auto-require the appraisal gem | n/a — Appraisal removed | — |

## Standing divergences

Where a port deliberately differs from upstream's own patch. Each is correct *for this fork*; changing one to match upstream would reintroduce a bug.

**`Association#inverse_of`** (from `91e9cca8`) resolves the declared `inverse_of:`, then the inverse ActiveRecord resolves for the reflection, then a polymorphic `as:` — and honours `inverse_of: false`. Upstream reads only the declared option and `as`.

- The middle step exists because this fork is ActiveRecord-only. Upstream's adapter also serves Mongoid, which resolves no inverse, so `as` is the only source available to both. Without the middle step, a conventional pair that declares nothing on either side reports no inverse and keeps rendering its back-reference.
- Honouring `inverse_of: false` matters because `false.try(:to_sym)` is `nil`, so upstream's `|| as` silently reinstates an inverse the host explicitly declined.
- The order is load-bearing. Reading the declared option first is what keeps a polymorphic `belongs_to` that declares an inverse from raising inside Rails' reflection, where the class cannot be computed.

**`FormBuilder#nested_field_association?`** (from the same commit) limits its hoisted name-match branch to association fields. Upstream's hoist is unconstrained. A polymorphic `as:` is never validated against the child class, so without the limit a plain column sharing that name can be suppressed from a subform.

**`sanitize_params_for!`** drops the parent's inverse from the nested allowlist, which upstream does not do at all — its permitted keys are derived purely from the visible fields. Hiding the back-reference without narrowing the allowlist left a collection subform re-parentable through a crafted `<assoc>_attributes[n]`, since `assign_nested_attributes_for_collection_association` assigns straight onto an already-associated record ([#24](https://github.com/6temes/rails_admin_next/pull/24)).

**`Field::Base#valid_length` drops Symbol bounds as well as Proc ones** (from `9336ec71`), and drops them only from the three keys that get compared (`LENGTH_BOUNDS`). Upstream drops every Proc-valued entry and no Symbols at all.

- ActiveModel sanctions four bound types and resolves Proc and Symbol against the record at validation time, so neither can be compared against the column limit. Measured here: `minimum: :some_method` raised the same `ArgumentError` upstream's fix addresses for Procs, and a surviving `maximum: :some_method` rendered "Length up to max_len" as help text.
- The narrowing to three keys exists because `valid_length` is a `register_instance_option` that host apps read. Rejecting every Proc, as upstream does, would also strip `if:`/`unless:` conditions from the hash.
- `:in` and `:within` need no entry: ActiveModel collapses them to `:minimum`/`:maximum` at validator construction, and a Proc passed as `:in` raises at declaration time.

**`StatementBuilder#to_statement` excludes `between` from the `_discard` strip** (from `897ffc13`), and strips only when the array actually contained the sentinel. Upstream strips unconditionally.

- `between` reads its value array by index, so removing an element shifts the range ends. Measured: `["ignored", "_discard", "20"]` became a `>= 20` filter where it had been `<= 20`.
- An array that arrived empty is not an array the strip emptied. A date filter legitimately submits `{v: [], o: "today"}`, carrying its meaning in the operator alone; returning early on any empty array breaks it.
- Upstream's client-side half is deliberately not ported. `filter_box_controller` here sets `disabled` on the sentinel options in multi-select mode, not merely `hidden`, and a disabled `<option>` is excluded from form submission — a stronger guarantee than upstream's deselect.

**The engine's stylesheet and style-preload tags carry the CSP nonce** (from `1f681b48`), but `csp_meta_tag` does not ship. Turbo reads that meta to re-nonce scripts it re-activates, and this engine renders no body script for it to re-activate; the nonce generator here is also per-request random, which a cached Turbo snapshot would carry stale. Adding the meta wants that generator decision alongside it.

## Assessing the next batch

```bash
git fetch upstream
git log --oneline --first-parent 897ffc13..upstream/master
```

`--first-parent` is load-bearing. Upstream folds whole histories in from time to time — `70ca765e` merged its GitHub wiki into `docs/`, and a plain `git log` across it turns an 18-commit batch into 1301, the extra 1283 being someone else's markdown. Check anything that is a merge (`git log -1 --format='%P %s' <sha>`) for what it actually brought in: vendored docs are one row, a merged feature branch needs its commits triaged individually.

Triage each commit by the **underlying problem**, not by the API, selector, or library its diff happens to touch. State the problem without naming any of them; if that sentence describes something possible here, the commit is relevant even when its diff is entirely in code this fork deleted.

`77e5d0bc` above is the cautionary case, and it cuts both ways. It was first dismissed as jQuery-UI-only, which was the wrong reason — the race it describes is stated in terms of a selector, and dismissing it on that vocabulary is exactly the mistake the rule above exists to prevent. But the CI failure that seemed to confirm the re-triage turned out to be an unrelated bug: an example reading the database before the server had answered ([#23](https://github.com/6temes/rails_admin_next/pull/23)). The widget itself stamps and aborts its requests, and instrumenting it showed one render per query, so the upstream race has no counterpart here.

**A coincident failure is not confirmation.** Look past a commit's vocabulary to decide whether it *could* apply, then measure this fork's own code before concluding that it does.
