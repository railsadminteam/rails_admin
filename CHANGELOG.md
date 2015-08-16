# RailsAdmin Changelog

## [0.7.0](https://github.com/sferik/rails_admin/tree/v0.7.0) - 2015-08-16

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.6.8...v0.7.0)

### Added
- Support for ActiveRecord::Enum (#1993)
- Multiselect-widget shows user friendly message, instead of just being blank (#1369, #2360)
- Configuration option to turn browser validation off (#2339, #2373)

### Changed
- Multiselect-widget inserts a new item to the bottom, instead of top (#2167)
- Migrated Cerulean theme to Bootstrap3 (#2352)
- Better html markup for input fields (#2336)
- Update filter dropdown button to Bootstrap3 (#2277)
- Improve navbar appearance (#2310)
- Do not monkey patch the app's YAML (#2331)

### Fixed
- Browser validation prevented saving of persisted upload fields (#2376)
- Fix inconsistent styling in static_navigation (#2378)
- Fix css regression for has_one and has_many nested form (#2337)
- HTML string inputs should not have a size attribute valorized with 0 (#2335)

### Security
- Fix XSS vulnerability in filtering-select widget
- Fix XSS vulnerability in association fields (#2343)
