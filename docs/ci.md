# Continuous integration

RailsAdmin runs its test suite on GitHub Actions — see
[`.github/workflows/test.yml`](../.github/workflows/test.yml).

The `RSpec` job is a matrix over:

- **Ruby**: 2.7 – 3.4, plus jruby-9.4
- **Rails**: 7.0 – 8.1 (via the `gemfiles/*.gemfile` Appraisal bundles)
- **ORM**: `active_record`, `mongoid` (`CI_ORM`)
- **Database**: sqlite3, mysql2, postgresql (`CI_DB_ADAPTER`)
- **Asset delivery**: `propshaft`, `sprockets`, `external` (`CI_ASSET`)

Only the `external` rows install Node and run `npm ci` / `npm run build`;
`propshaft` and `sprockets` serve the committed `app/assets/builds` bundle with
no Node, which keeps the no-build path honest.

Separate jobs:

- **Precompiled assets** — rebuilds `app/assets/builds` on Node 20 and 22 and
  fails if the committed output drifts
- **Prettier** — `npm run format:check` over `src/`
- **RuboCop**

Run the suite locally with `bundle exec rspec`; pick a pipeline with
`CI_ASSET=propshaft bundle exec rspec` (defaults vary — check `spec/spec_helper.rb`).
