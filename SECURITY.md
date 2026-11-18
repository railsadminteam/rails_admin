# Security Policy

## Supported versions

`rails_admin_next` targets a single supported runtime: Ruby >= 4.0, Rails ~> 8.1,
ActiveRecord, and the importmap + Propshaft asset pipeline. Security fixes land on the
latest `1.x` release.

| Version | Supported                                                   |
| ------- | ----------------------------------------------------------- |
| 1.x     | yes                                                         |
| < 1.0   | no (the pre-fork `rails_admin` gem; unrelated release line) |

## Reporting a vulnerability

Please report security issues privately via GitHub's **"Report a vulnerability"** button on the
repository's _Security_ tab (private security advisories), not through a public issue or pull
request. Include a description, affected versions, and a reproduction if possible. You will get an
acknowledgement and a remediation timeline.

For the admin's request-forgery, clickjacking, export, destructive-action, mass-assignment, and
Content-Security-Policy posture (and the one host opt-in), see [`docs/security.md`](docs/security.md).

## Automated scanning

CI gates every push on:

- **brakeman** — static analysis (`bundle exec brakeman -A`). Reviewed false positives live in
  [`config/brakeman.ignore`](config/brakeman.ignore), each with a written justification.
- **Dependabot** — weekly `github-actions` update PRs
  ([`.github/dependabot.yml`](.github/dependabot.yml)), plus gem alerts and automated security
  fixes. No `bundler` version updates run: `Gemfile.lock` is not committed, so CI already
  resolves the newest allowed gems on every run. Without a lockfile, Dependabot alerts cover
  only the gems declared in `Gemfile` and `*.gemspec`, and the `bundler-audit` CI gate was
  retired in July 2026, so advisories for transitive gems may go untracked here. Advisories
  Dependabot cannot fix — one with no patched release exists, `CVE-2026-38969` in `webrick` —
  are tracked by hand as issues.
- **Standard** and **Prettier** — Ruby and JS/CSS style gates.

## Importmap pins: fully self-hosted (jspm blind spot closed)

The engine's importmap ([`config/importmap.rails_admin.rb`](config/importmap.rails_admin.rb)) pins
**only self-hosted assets** — there are no external CDN URLs (`grep jspm.io` returns nothing). Every
third-party module resolves from a file on the Propshaft load path, served and fingerprinted
same-origin:

- `@hotwired/stimulus`, `@hotwired/turbo-rails` → the `stimulus-rails` / `turbo-rails` gems.
- `@rails/actioncable`, `@rails/activestorage`, `@rails/actiontext` → the `actioncable` /
  `activestorage` / `actiontext` gems (all pulled in by the `rails` dependency; `action_cable/engine`
  is `require`d in [`lib/rails_admin_next/engine.rb`](lib/rails_admin_next/engine.rb) so its asset
  path registers).
- `trix` → the `action_text-trix` gem (loaded with ActionText).
- `rails_admin_next/*` → the engine's own source under `src/`, versioned with the gem.

Because every pinned module ships inside a gem, the front-end JS is versioned in lockstep with
those gems. A host moves them when it updates its own lockfile, by hand or through its own
Dependabot, and this repository's CI resolves the newest allowed versions on every run. The
previous jspm.io blind spot (pins that no manifest declared and Dependabot could not see) is
**closed**; there is nothing left to hand-audit in the importmap.

### No external front-end network surface

There is **no remaining external CDN or third-party network dependency** in the engine's front-end —
default or opt-in. The previously cdnjs-backed rich-text/code editors (CKEditor, CodeMirror,
SimpleMDE) have been removed; rich text is now served exclusively by the self-hosted ActionText/Trix
pin, and any other text field renders a plain textarea. Every asset the engine serves resolves
same-origin off a gem on the Propshaft load path.

- **Tooling:** the repository's `update-importmap` workflow automates the detect → audit →
  re-vendor/re-pin loop for the self-hosted front-end dependencies.
