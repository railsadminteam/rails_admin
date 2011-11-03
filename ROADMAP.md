# Roadmap

## Version 0.1.0

## I18n
- keys are in a huge mess. Refactor :en and let translators catch-up before release. 
- add some doc for github online fast-edit solutions (translators != dev)

## html/CSS/JS
- Needs testing: Android, IE7.
- Fix CSS bug in IE (bootstrap-sass related, may fix with bootstrap 1.4 or bootstrap-less)
- Fix all JS bugs on IE7+ (IE8+ seems to be fine)
- Move all JS code to coffee
- Move all CSS code to less, or default to scss (depending on rails-less/rails-sass feature sets and bootstrap-sass support)
- support should target IE7+ with focus on future-proofing, through well-tested libraries (Bootstrap, JQuery)

## Tests
- Move all functional testing to better targeted Unit tests
- Tests views with JS enabled
- Make some *compact* and *fast* functional testing with cucumber
- No more 'view testing' for new developments

## Docs
- document all field types and all relations types with their specificities against Field::Base
- remove deprecations

## Views
### Form
#### `has\_many`, `has\_one`
- make possible to use nested forms instead of widget/modal
- offer the possibility to fetch only non-associated records if sticking to widget (make it configurable).
- drop hackish ActiveRecord support for has_many style `has\_one` or improve it to current quality standards

#### `has\_many :through`, `habtm`
- re-add prepopulation for widget keeping concistancy with xhr
- find a solution for mobile devices (currently not intuitive)

#### `belongs\_to`
- re-add prepolation keeping concistancy with xhr

#### images
- move 90% of paperclip non-specific code to parent (upload)
- implement DragonFly on top of it
- implement CarrierWave on top of it
- improve base widget

#### Groups
- better defaults (one group for each relation is dumb and group legend is repeated uselessly in field legend)

#### Modals
- desactivate add button if target requires source id to validate and source is a new record
- replace :inverse_of widget with hidden field filled with source id if target requires source and target is a new record and source is a saved record
- desactivate :inverse_of widget on target modal if not required and empty
- identify all such cases and add them here

