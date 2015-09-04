[[Troubleshoot? check me first|Troubleshoot]]

### Overview

1. [[Introduction to RailsAdmin|http://www.slideshare.net/benoitbenezech/rails-admin-overbest-practices]]

### Configuration

1. [[Base RailsAdmin configuration|Base configuration]]
2. [[Actions]]
3. [[Navigation]]
4. [[Models]]
5. [[Groups]]
6. [[Fields]]
7. [[Translations]]

### Integration Testing

[[Rspec with Capybara examples]]

### Actions

[[Base|Base Action]]

* Root actions
  * [[Dashboard|Dashboard Action]]
* Collection actions
  * [[Index|Index Action]]
  * [[New|New Action]]
  * [[Export|Export Action]]
  * [[HistoryIndex|History Index Action]]
  * [[BulkDelete|Bulk Delete Action]]
* Member actions
  * [[Show|Show Action]]
  * [[Edit|Edit Action]]
  * [[Delete|Delete Action]]
  * [[HistoryShow|History Show Action]]
  * [[ShowInApp|Show In App Action]]

### Field types

[[Base|Base Field]]

* [[FileUpload|File Upload]]
  * [[Paperclip]]
  * [[Dragonfly]]
  * [[Carrierwave]]
* [[Enumeration]]
* [[Boolean]]
* [[Decimal]]
* [[Integer]]
* [[Float]]
* [[Hidden]]
* [[String]]
  * [[Password]]
* [[Text]]
  * [[CKEditor]]
  * [[CodeMirror]]
  * [[Wysihtml5]]
  * [[Froala WYSIWYG HTML Editor]]
* [[Timestamp - Date  - Datetime - Time|Timestamp---Date---Datetime---Time]]


### Associations

* [[Associations basics]]
* [[Associations scoping]]
* [[Associations validation]]

### Associations types

* [[belongs_to association|Belongs-to-association]]
  * [[polymorphic belongs_to association|Polymorphic-belongs-to-association]]
* [[has_one association|Has-one-association]]
* [[has_many association|Has-many-association]]
  * [[has_and_belongs_to_many association|Has-and-belongs-to-many-association]]
  * [[has_many :through association|Has-many-:through-association]]


### Sections

[[Base]]

* [[List]]
* [[Show]]
* [[Export]]
* [[Edit]]
  * [[Create]]
  * [[Update]]
  * [[Nested]]
  * [[Modal]]


### User integration

* [[Authentication]]
* [[Authorization]]
* [[Mass-assignments protection]]
* [[Auditing changes|Auditing]]

### Extend RailsAdmin (RailsAdmin API)

* [[Theming and customization]]
* [[Custom action]]
* [[Custom field]]

### Styling

* [[List view table styling]]
* [[Horizontally scrolling table with frozen columns in list view]]

### Routing

* [[Routing Problems]]
* [[Using RailsAdmin routes]]


### Recipes

* [[How to set default values]]


### Plugins

#### Authorization/Auditing
* [RailsAdminAuthorizedFields](https://github.com/xronos-i-am/rails_admin_authorized_fields): Simplified authorization rules for models' fields in rails_admin
* [RailsAdminHisteroid](https://github.com/franc/rails_admin_histeroid): Mongoid 3.1 history audit support
* [RailsAdminHistoryRollback](https://github.com/rikkipitt/rails_admin_history_rollback): PaperTrail history rollback
* [RailsAdminPundit](https://github.com/sudosu/rails_admin_pundit): Integration with Pundit authorization system

#### Field extension
* [Enumerize](https://github.com/brainspec/enumerize): Enumerated attributes with I18n and ActiveRecord/Mongoid support
* [RailsAdminCharts](https://github.com/pgeraghty/rails_admin_charts): Charts using Highcharts
* [RailsAdminDynamicCharts](https://github.com/openjaf/rails_admin_dynamic_charts): Dynamic Charts
* [RailsAdminGlobalizeField](https://github.com/scarfaceDeb/rails_admin_globalize_field): Tabbed interface and custom field type for globalize3 translations
* [RailsAdminJcrop](https://github.com/janx/rails_admin_jcrop): Image cropping with rails_admin_jcrop
* [RailsAdminMapField](https://github.com/trademobile/rails_admin_map_field): Coordinates with Google Maps
* [RailsAdminMongoidGeospatialField](https://github.com/sudosu/rails_admin_mongoid_geospatial_field): Support for setting geospatial information with Google Maps into Mongoid's GEO2D field
* [RailsAdminMongoidLocalizeField](https://github.com/sudosu/rails_admin_mongoid_localize_field): Support for mongoid localized fields
* [RailsAdminNestable](https://github.com/dalpo/rails_admin_nestable): Drag and drop tree view for Ancestry gem
* [RailsAdminNestedSet](https://github.com/rs-pro/rails_admin_nested_set): Drag and drop tree view for Awesome Nested Set / mongoid nested set
* [RailsAdminPlaceField](https://github.com/thinkclay/rails_admin_place_field): Google Maps with Places and Foursquare Venues
* [RailsAdminRedactor](https://github.com/anarchocurious/rails-admin-redactor): Adds support for the [Redactor](http://imperavi.com/redactor/) wysiwyg editor
* [RailsAdminTagList](https://github.com/kryzhovnik/rails_admin_tag_list): ActsAsTaggableOn tag_list field
* [RailsUploader](https://github.com/glebtv/rails-uploader): Nice mass file uploads with jQuery File Upload for rails_admin and mongoid
* [Rich](https://github.com/bastiaanterhorst/rich): an opinionated CKEditor implementation with file uploads
* [RailsAdminCountries](https://github.com/xronos-i-am/rails_admin_countries): Add [countries](https://github.com/hexorx/countries) gem support

#### Custom action
* [RailsAdminClone](https://github.com/dalpo/rails_admin_clone): Clone records
* [RailsAdminImport](https://github.com/stephskardal/rails_admin_import): Import data from a CSV or JSON file
* [RailsAdminState](https://github.com/rs-pro/rails_admin_state): Manage state_machine states with rails_admin
* [RailsAdminAasm](https://github.com/zcpdog/rails_admin_aasm): Manage aasm states with rails_admin
* [RailsAdminToggleable](https://github.com/rs-pro/rails_admin_toggleable): Toggle boolean fields in index view

#### Misc.
* [RailsAdminSettings](https://github.com/rs-pro/rails_admin_settings): Application setting for rails_admin and mongoid
* [RailsAdminGrid](https://github.com/colavitam/rails_admin_grid): Custom collection (index) action that displays objects in a grid with thumbnails