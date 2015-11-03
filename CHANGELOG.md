# RailsAdmin Changelog

## [Unreleased](https://github.com/sferik/rails_admin/tree/HEAD)

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.7.0...HEAD)

### Added
- Pundit integration([#2399](https://github.com/sferik/rails_admin/pull/2399) by Team CodeBenders, RGSoC'15)
- Refile support([#2385](https://github.com/sferik/rails_admin/pull/2385))

### Changed
- Improve efficiency of filter query in Postgres([#2401](https://github.com/sferik/rails_admin/pull/2401))
- Replace old jQueryUI datepicker with jQuery Bootstrap datetimepicker ([#2391](https://github.com/sferik/rails_admin/pull/2391))
- Turn Hash#symbolize into a helper to prevent namespace conflict([#2388](https://github.com/sferik/rails_admin/pull/2388))

### Deprecated
- The L10n translation `admin.misc.filter_date_format` datepicker search filters, has been dropped in favor of field oriented configuration ([#2391](https://github.com/sferik/rails_admin/pull/2391))

### Fixed
- Add button for nested-many form in modal disappeared on click([#2372](https://github.com/sferik/rails_admin/issues/2372), [#2383](https://github.com/sferik/rails_admin/pull/2383))


## [0.7.0](https://github.com/sferik/rails_admin/tree/v0.7.0) - 2015-08-16

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.6.8...v0.7.0)

### Added
- Support for ActiveRecord::Enum ([#1993](https://github.com/sferik/rails_admin/issues/1993))
- Multiselect-widget shows user friendly message, instead of just being blank ([#1369](https://github.com/sferik/rails_admin/issues/1369), [#2360](https://github.com/sferik/rails_admin/pull/2360))
- Configuration option to turn browser validation off ([#2339](https://github.com/sferik/rails_admin/pull/2339), [#2373](https://github.com/sferik/rails_admin/pull/2373))

### Changed
- Multiselect-widget inserts a new item to the bottom, instead of top ([#2167](https://github.com/sferik/rails_admin/pull/2167))
- Migrated Cerulean theme to Bootstrap3 ([#2352](https://github.com/sferik/rails_admin/pull/2352))
- Better html markup for input fields ([#2336](https://github.com/sferik/rails_admin/pull/2336))
- Update filter dropdown button to Bootstrap3 ([#2277](https://github.com/sferik/rails_admin/pull/2277))
- Improve navbar appearance ([#2310](https://github.com/sferik/rails_admin/pull/2310))
- Do not monkey patch the app's YAML ([#2331](https://github.com/sferik/rails_admin/pull/2331))

### Fixed
- Browser validation prevented saving of persisted upload fields ([#2376](https://github.com/sferik/rails_admin/issues/2376))
- Fix inconsistent styling in static_navigation ([#2378](https://github.com/sferik/rails_admin/pull/2378))
- Fix css regression for has_one and has_many nested form ([#2337](https://github.com/sferik/rails_admin/pull/2337))
- HTML string inputs should not have a size attribute valorized with 0 ([#2335](https://github.com/sferik/rails_admin/pull/2335))

### Security
- Fix XSS vulnerability in filtering-select widget
- Fix XSS vulnerability in association fields ([#2343](https://github.com/sferik/rails_admin/issues/2343))
