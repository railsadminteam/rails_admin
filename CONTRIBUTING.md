# Contributing

In the spirit of [free software][free-sw], **everyone** is encouraged to help improve
this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways _you_ can contribute:

- by triaging bug reports
- by writing or editing documentation
- by writing specifications
- by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
- by refactoring code
- by fixing [issues][]
- by reviewing patches
- by suggesting new features

[issues]: https://github.com/6temes/rails_admin_next/issues

## Development

RailsAdminNext targets a **single supported runtime** — Ruby 4.0, Rails ~> 8.1,
ActiveRecord, and an importmap + Propshaft asset pipeline. There is **no multi-ORM,
multi-bundler, or multi-Rails build matrix**, and **no Appraisal**: the suite runs against
one Gemfile with no `yarn build` step.

The gem expects evergreen hosts (see [Requirements](README.md#requirements)), so a Ruby
bump moves the CI pin and the floor together: `required_ruby_version`, `.standard.yml`,
the demo `Dockerfile`, and the versions quoted in the docs.

The gem has no application of its own; it is developed and tested against the embedded
host app at `spec/dummy_app/`.

### Prerequisites

To run the suite you need:

- **Google Chrome** — the `js: true` specs run in headless Chrome driven by Cuprite/Ferrum.
- **libvips** — required by the image-field specs (ActiveStorage's `:vips` variant processor;
  the `ruby-vips` gem dlopens the libvips shared library).

Example installation on macOS using Homebrew:

```bash
brew install vips
brew install --cask google-chrome
```

Example installation on Ubuntu:

```bash
sudo apt-get update -y && sudo apt-get install -y libvips-dev
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
```

### Setup

```bash
bundle install

# Provision the dummy app database (database.yml is generated, not committed):
cd spec/dummy_app
bundle exec rake rails_admin:prepare_ci_env db:create db:schema:load
cd -
```

There is no `yarn install`/`yarn build` step — the engine serves browser-native ESM and
CSS over importmap + Propshaft, so the assets need no compilation before the suite runs.

### Running tests

```bash
bundle exec rspec                                       # full suite (sqlite3)
bundle exec rspec spec/integration/actions/show_spec.rb # single file
bundle exec rspec spec/integration/actions/show_spec.rb:42  # single example by line
```

The test run reads two environment variables:

- `CI_DB_ADAPTER` — `sqlite3` (default), `postgresql`, or `mysql2`. It is consumed by the
  `rails_admin:prepare_ci_env` rake task, which (re)writes `spec/dummy_app/config/database.yml`.
  Re-run the provision step above after changing it.
- `RAILS_ENV` — `test`.

```bash
# Run against PostgreSQL (re-provision the database first, then run the suite):
cd spec/dummy_app && CI_DB_ADAPTER=postgresql bundle exec rake rails_admin:prepare_ci_env db:create db:schema:load && cd -
CI_DB_ADAPTER=postgresql bundle exec rspec
```

There is no `spec/rails_helper.rb`: every spec does `require 'spec_helper'`, and
`spec/spec_helper.rb` boots `spec/dummy_app/config/environment`.

### Lint and security gates

CI gates every push on the following checks. Run them locally before
opening a pull request:

```bash
bundle exec standardrb                 # Ruby style
bundle exec brakeman -A --no-pager     # static security analysis
npx --yes prettier@2.8.8 --check .     # JS/CSS formatting (no package.json; pinned via npx)
```

`bundle exec rake` runs the default task — the spec suite followed by Standard. It does
**not** run Prettier or Brakeman, so run those separately.

The importmap pins the engine self-hosts are a [Dependabot blind spot](SECURITY.md);
they are audited by hand on the cadence documented in [SECURITY.md](SECURITY.md).

## Submitting an issue

If you're confident that you've found a bug, please [open an issue][issues] after checking
that it hasn't already been reported. Include the steps to reproduce, a stack trace, and
your gem version, Ruby version, and operating system. Ideally, a bug report includes a
pull request with failing specs.

## Submitting a pull request

1. [Fork the repository.][fork]
2. Create a branch.
3. Add specs for your unimplemented feature or bug fix.
4. Implement your feature or bug fix.
5. Run `bundle exec rake`. If anything fails, return to step 4.
6. Run the lint and security gates above.
7. Add, commit, and push your changes.
8. [Submit a pull request.][pr]

CI runs on pushes to this repository, not on pull requests, so a pull request from a fork
shows no checks until a maintainer pushes its head commit to a branch here. That push runs
the workflow files in that commit, not the ones on `main`, so review its `.github/workflows`
changes before pushing it.

[fork]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
[pr]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request

## Releasing (maintainers)

Publishing the release draft is the whole release: there is no version-bump commit, no local step and no API key.

1. Every push to `main` updates a draft GitHub release from the merged pull request titles. Its version bumps the highest published release: a pull request labelled `major` or `minor` bumps that part, and any other pull request bumps the patch.
2. Publish the draft. Its `vX.Y.Z` tag runs `release.yml`, which runs `ci.yml` on the tagged commit and, only if that passes, stamps the version into `lib/rails_admin_next/version.rb` with `bin/stamp-version`, builds the gem and pushes it through RubyGems trusted publishing in the `release` environment.

`lib/rails_admin_next/version.rb` is never bumped by hand: its constants are only what a local `gem build` produces.

Release Drafter skips prereleases: drafts are never prereleases, and a published prerelease is ignored when it picks the release to bump from.

The trusted publisher on rubygems.org must name workflow `release.yml` and environment `release`; a blank environment field accepts any environment.

### Recovering from a failed publish

Release tags are never moved or deleted. If the `Release` run fails, in `ci` or in `publish`, fix the cause and re-run its failed jobs on the same tag. If that tag cannot be released, because the tagged commit is broken or the run is too old to re-run, leave its tag and release in place and ship the fix as the next version. Before publishing that next draft, regenerate its notes by running the `Release Drafter` workflow on `main` from the Actions tab, and add back any changes the failed release never shipped.
