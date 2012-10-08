[[Troubleshoot? check me first|Troubleshoot]]

### Configuration

1. [[Base RailsAdmin configuration|Base configuration]]
2. [[Actions]]
3. [[Navigation]]
4. [[Fields configuration|Railsadmin-DSL]]
5. [[Translations]]

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
  * [[With Devise (installed by default)|https://github.com/plataformatec/devise]]
  * [[Manually|https://gist.github.com/1278355]]
  * [[Sorcery]]
  * [[None|no authentification]]
* [[Authorization setup]]
  * [[CanCan (recommended)|CanCan]]
  * [[CanCan with relation to current Model|CanCan:-remove-associated-action-buttons-in-forms]]
  * [[Declarative Authorization (possible)|Declarative Authorization]]
  * [[Manually|Customized authorization]]
* [[Mass-assignments protection]]
* Auditing (change historic)
  * [[History (internal)|History]]
  * [[PaperTrail (recommended)|PaperTrail]]
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
* [Drag and drop tree view](https://github.com/dalpo/rails_admin_nestable)
* [Histeroid: Mongoid 3.1 history audit support](https://github.com/franc/rails_admin_histeroid)
 