# Roadmap

## Version 0.1.0

### filters

- select for belongs_to < 30 records
- simplify search conf if > 30 records
- date select

### html/CSS/JS

- Needs testing: Android, IE7.
- Fix all JS bugs on IE7+ . Found visual bug in multiselect

### Tests

- Move all functional testing to better targeted Unit tests
- Tests views with JS enabled
- Make some _compact_ and _fast_ functional testing with cucumber

### Docs

### `has_many`, `has_one`

- offer the possibility to fetch only non-associated records if sticking to widget (make it configurable).

### `has_many :through`, `habtm`

- find a solution for mobile devices (currently not intuitive)

### Modals

- desactivate add button if target requires source id to validate and source is a new record
- replace :inverse_of widget with hidden field filled with source id if target requires source and target is a new record and source is a saved record
- desactivate :inverse_of widget on target modal if not required and empty
- identify all such cases and add them here
