[[Troubleshoot? check me first|Troubleshoot]]

### Overview

1. [[Introduction to RailsAdmin|http://www.slideshare.net/benoitbenezech/rails-admin-overbest-practices]]

### Configuration

1. [[Base RailsAdmin configuration|Base configuration]]
2. [[Actions]]
3. [[Navigation]]
4. [[Fields configuration|Railsadmin-DSL]]
5. [[Translations]]

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
  * [[HistoryIndex|HistoryIndex Action]]
  * [[BulkDelete|BulkDelete Action]]
* Member actions
  * [[Show|Show Action]]
  * [[Edit|Edit Action]]
  * [[Delete|Delete Action]]
  * [[HistoryShow|HistoryShow Action]]
  * [[ShowInApp|ShowInApp Action]]

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

### Routing

* [[Routing Problems]]
* [[Using RailsAdmin routes]]


### Recipes

* [[How to set default values]]


### Plugins

#### Authorization/Auditing
* [__RailsAdminAuthorizedFields__: Simplified authorization rules for models' fields in rails_admin](https://github.com/xronos-i-am/rails_admin_authorized_fields)
* [__RailsAdminHisteroid__: Mongoid 3.1 history audit support](https://github.com/franc/rails_admin_histeroid)
* [__RailsAdminHistoryRollback__: PaperTrail history rollback](https://github.com/rikkipitt/rails_admin_history_rollback)
* [__RailsAdminPundit__: Integration with Pundit authorization system](https://github.com/sudosu/rails_admin_pundit)

#### Field extension
* [__Enumerize__: Enumerated attributes with I18n and ActiveRecord/Mongoid support](https://github.com/brainspec/enumerize)
* [__RailsAdminCharts__: Charts using Highcharts](https://github.com/pgeraghty/rails_admin_charts)
* [__RailsAdminDynamicCharts__: Dynamic Charts](https://github.com/openjaf/rails_admin_dynamic_charts)
* [__RailsAdminJcrop__: Image cropping with rails_admin_jcrop](https://github.com/janx/rails_admin_jcrop)
* [__RailsAdminMapField__: Coordinates with Google Maps](https://github.com/trademobile/rails_admin_map_field)
* [__RailsAdminMongoidGeospatialField__: Support for setting geospatial information with Google Maps into Mongoid's GEO2D field](https://github.com/sudosu/rails_admin_mongoid_geospatial_field)
* [__RailsAdminNestable__: Drag and drop tree view for Ancestry gem](https://github.com/dalpo/rails_admin_nestable)
* [__RailsAdminNestedSet__: Drag and drop tree view for Awesome Nested Set / mongoid nested set](https://github.com/rs-pro/rails_admin_nested_set)
* [__RailsAdminPlaceField__: Google Maps with Places and Foursquare Venues](https://github.com/thinkclay/rails_admin_place_field)
* [__RailsAdminTagList__: ActsAsTaggableOn tag_list field](https://github.com/kryzhovnik/rails_admin_tag_list)
* [__RailsUploader__: Nice mass file uploads with jQuery File Upload for rails_admin and mongoid](https://github.com/glebtv/rails-uploader)
* [__Rich__: an opinionated CKEditor implementation with file uploads](https://github.com/bastiaanterhorst/rich)

#### Custom action
* [__RailsAdminClone__: Clone records](https://github.com/dalpo/rails_admin_clone)
* [__RailsAdminImport__: Import data from a csv file](https://github.com/stephskardal/rails_admin_import) 
* [__RailsAdminImport++__: Extends import plugin. Allows the user to set a key field to lookup records, updating if the record exists and creating a new records otherwise. Also allows user to immigrate records from an rss feed. Experimental.](https://github.com/adamwong246/rails_admin_import) 
* [__RailsAdminState__: Manage state_machine states with rails_admin](https://github.com/rs-pro/rails_admin_state)
* [__RailsAdminToggleable__: Toggle boolean fields in index view](https://github.com/rs-pro/rails_admin_toggleable)

#### Misc.

* [__RailsAdminGlobalizedField__: Tabbed interface and custom field type for globalize3 translations](https://github.com/scarfaceDeb/rails_admin_globalize_field)
* [__RailsAdminMongoidLocalizedField__: Support for mongoid localized fields](https://github.com/sudosu/rails_admin_mongoid_localize_field)
* [__RailsAdminSetting__: Application setting for rails_admin and mongoid](https://github.com/rs-pro/rails_admin_settings)
