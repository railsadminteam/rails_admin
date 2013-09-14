[[Troubleshoot? check me first|Troubleshoot]]

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
  * With [[Devise|https://github.com/plataformatec/devise]] (installed by default)
  * [[Sorcery]]
  * [[Manually (without Devise)]]
* [[Authorization setup]]
  * [[CanCan (recommended)|CanCan]]
  * [[CanCan with relation to current Model|CanCan:-remove-associated-action-buttons-in-forms]]
  * [[Declarative Authorization (possible)|Declarative Authorization]]
  * [[Manually|Customized authorization]]
* [[Mass-assignments protection]]
* Auditing (change history)
  * [[History (internal)|History]]
  * [[PaperTrail (recommended)|PaperTrail]]
  * [mongoid_audit](https://github.com/rs-pro/mongoid-audit)
  * None. (Default)

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

* [Coordinates with Google Maps](https://github.com/trademobile/rails_admin_map_field)
* [ActsAsTaggableOn tag_list field](https://github.com/kryzhovnik/rails_admin_tag_list)
* [Rich: an opinionated CKEditor implementation with file uploads](https://github.com/bastiaanterhorst/rich)
* [Image cropping with rails_admin_jcrop](https://github.com/janx/rails_admin_jcrop)
* [Drag and drop tree view for Ancestry gem](https://github.com/dalpo/rails_admin_nestable)
* [Drag and drop tree view for Awesome Nested Set / mongoid nested set](https://github.com/rs-pro/rails_admin_nested_set)
* [Histeroid: Mongoid 3.1 history audit support](https://github.com/franc/rails_admin_histeroid)
* [Import: Import data from a csv file](https://github.com/stephskardal/rails_admin_import) 
* [Import++ Extends import plugin. Allows the user to set a key field to lookup records, updating if the record exists and creating a new records otherwise. Also allows user to immigrate records from an rss feed. Experimental.](https://github.com/adamwong246/rails_admin_import) 
* [Toggle boolean fields in index view](https://github.com/rs-pro/rails_admin_toggleable)
* [Enumerize: Enumerated attributes with I18n and ActiveRecord/Mongoid support](https://github.com/brainspec/enumerize)
* [Application setting for rails_admin and mongoid](https://github.com/rs-pro/rails_admin_settings)
* [Nice mass file uploads with jQuery File Upload for rails_admin and AR/mongoid](https://github.com/glebtv/rails-uploader)
* [Charts using Highcharts](https://github.com/pgeraghty/rails_admin_charts)
* [Manage state_machine states with rails_admin](https://github.com/rs-pro/rails_admin_state)
