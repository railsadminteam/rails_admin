# Roadmap

## Version 0.0.0

Empty milestone's tickets in Github.

## Version 0.1.0

### I18n
- keys are in a huge mess. Refactor :en and let translators catch-up before release. 
- add some doc for github online fast-edit solutions (translators != dev)

### html/CSS/JS
- Needs testing: Android, IE7.
- Fix CSS bug in IE (bootstrap-sass related)
- Fix all JS bugs on IE7+ . Found visual bug in multiselect
- Move all JS code to coffee
- support should target IE7+ with focus on future-proofing, through well-tested libraries (Bootstrap, JQuery)

### Tests
- Move all functional testing to better targeted Unit tests
- Tests views with JS enabled
- Make some *compact* and *fast* functional testing with cucumber
- No more 'view testing' for new developments

### Docs
- document all field types and all relations types with their specificities against Field::Base

### `has_many`, `has_one`
- offer the possibility to fetch only non-associated records if sticking to widget (make it configurable).

### `has_many :through`, `habtm`
- find a solution for mobile devices (currently not intuitive)

### Groups
- better defaults (one group for each relation is dumb and group legend is repeated uselessly in field legend)

### Modals
- desactivate add button if target requires source id to validate and source is a new record
- replace :inverse_of widget with hidden field filled with source id if target requires source and target is a new record and source is a saved record
- desactivate :inverse_of widget on target modal if not required and empty
- identify all such cases and add them here

### History
- refactor old history in a separate gem
- add tested compatibility layer for PaperTrail