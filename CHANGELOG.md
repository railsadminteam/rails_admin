# RailsAdmin Changelog

## [Unreleased](https://github.com/sferik/rails_admin/tree/HEAD)

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.8.1...HEAD)

### Fixed
- Fixed Mongoid BSON object field ([#2495](https://github.com/sferik/rails_admin/issues/2495))


## [0.8.1](https://github.com/sferik/rails_admin/tree/v0.8.1) - 2015-11-24

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.8.0...v0.8.1)

### Fixed
- `vendor/` directory was missing from gemspec([#2481](https://github.com/sferik/rails_admin/issues/2481), [#2482](https://github.com/sferik/rails_admin/pull/2482))


## [0.8.0](https://github.com/sferik/rails_admin/tree/v0.8.0) - 2015-11-23

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.7.0...v0.8.0)

### Added
- Feature to deactivate filtering-multiselect widget's remove buttons through `removable?` field option([#2446](https://github.com/sferik/rails_admin/issues/2446))
- Pundit integration([#2399](https://github.com/sferik/rails_admin/pull/2399) by Team CodeBenders, RGSoC'15)
- Refile support([#2385](https://github.com/sferik/rails_admin/pull/2385))

### Changed
- Some UI improvements in export view([#2394](https://github.com/sferik/rails_admin/pull/2394))
- `rails_admin/custom/variables.scss` is now imported first to take advantage of Sass's `default!`([#2404](https://github.com/sferik/rails_admin/pull/2404))
- Proxy classes now inherit from BasicObject([#2434](https://github.com/sferik/rails_admin/issues/2434))
- Show sidebar scrollbar only on demand([#2419](https://github.com/sferik/rails_admin/pull/2419))
- RailsAdmin no longer gets excluded from NewRelic instrumentation by default([#2402](https://github.com/sferik/rails_admin/pull/2402))
- Improve efficiency of filter query in Postgres([#2401](https://github.com/sferik/rails_admin/pull/2401))
- Replace old jQueryUI datepicker with jQuery Bootstrap datetimepicker ([#2391](https://github.com/sferik/rails_admin/pull/2391))
- Turn Hash#symbolize into a helper to prevent namespace conflict([#2388](https://github.com/sferik/rails_admin/pull/2388))

### Removed
- The L10n translation `admin.misc.filter_date_format` datepicker search filters, has been dropped in favor of field oriented configuration ([#2391](https://github.com/sferik/rails_admin/pull/2391))

### Fixed
- AR#count broke when default-scoped with select([#2129](https://github.com/sferik/rails_admin/pull/2129), [#2447](https://github.com/sferik/rails_admin/issues/2447))
- Datepicker could not handle Spanish date properly([#982](https://github.com/sferik/rails_admin/issues/982), [#2451](https://github.com/sferik/rails_admin/pull/2451))
- Paperclip's `attachment_definitions` does not exist unless `has_attached_file`-ed([#1674](https://github.com/sferik/rails_admin/issues/1674))
- `.btn` class was used without a modifier([#2417](https://github.com/sferik/rails_admin/pull/2417))
- Filtering-multiselect widget ignored order([#2231](https://github.com/sferik/rails_admin/issues/2231), [#2412](https://github.com/sferik/rails_admin/pull/2412))
- Add missing .alert-dismissible class to flash([#2411](https://github.com/sferik/rails_admin/pull/2411))
- Keep field order on changing the existing field's type([#2409](https://github.com/sferik/rails_admin/pull/2409))
- Add button for nested-many form in modal disappeared on click([#2372](https://github.com/sferik/rails_admin/issues/2372), [#2383](https://github.com/sferik/rails_admin/pull/2383))

### Security
- Fix XSS vulnerability in polymorphic select([#2479](https://github.com/sferik/rails_admin/pull/2479))


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
