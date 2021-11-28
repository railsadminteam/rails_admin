# Index

[Troubleshoot? check me first](troubleshoot.md)

### Overview

1. [Introduction to RailsAdmin](http://www.slideshare.net/benoitbenezech/rails-admin-overbest-practices)

### Configuration

1. [Base RailsAdmin configuration](base-configuration.md)
2. [Actions](actions.md)
3. [Navigation](navigation.md)
4. [Models](models.md)
5. [Groups](groups.md)
6. [Fields](fields.md)
7. [Translations](translations.md)

### Integration Testing

[Rspec with Capybara examples](rspec-with-capybara-examples.md)

### Actions

[Base](base-action.md)

- Root actions
  - [Dashboard](dashboard-action.md)
- Collection actions
  - [Index](index-action.md)
  - [New](new-action.md)
  - [Export](export-action.md)
  - [HistoryIndex](history-index-action.md)
  - [BulkDelete](bulk-delete-action.md)
- Member actions
  - [Show](show-action.md)
  - [Edit](edit-action.md)
  - [Delete](delete-action.md)
  - [HistoryShow](history-show-action.md)
  - [ShowInApp](show-in-app-action.md)

### Field types

[Base](base-field.md)

- [FileUpload](file-upload.md)
  - [ActiveStorage](activestorage.md)
  - [Carrierwave](carrierwave.md)
  - [Dragonfly](dragonfly.md)
  - [Paperclip](paperclip.md)
- [Enumeration](enumeration.md)
- [Boolean](boolean.md)
- [Decimal](decimal.md)
- [Integer](integer.md)
- [Float](float.md)
- [Hidden](hidden.md)
- [String](string.md)
  - [Password](password.md)
- [Text](text.md)
  - [ActionText](actiontext.md)
  - [CKEditor](ckeditor.md)
  - [CodeMirror](codemirror.md)
  - [Froala WYSIWYG HTML Editor](froala-wysiwyg-html-editor.md)
  - [Wysihtml5](wysihtml5.md)
- [Timestamp - Date - Datetime - Time](timestamp-date-datetime-time.md)

### Associations

- [Associations basics](associations-basics.md)
- [Associations scoping](associations-scoping.md)
- [Associations validation](associations-validation.md)

### Associations types

- [belongs_to association](belongs-to-association.md)
  - [polymorphic belongs_to association](polymorphic-belongs-to-association.md)
- [has_one association](has-one-association.md)
- [has_many association](has-many-association.md)
  - [has_and_belongs_to_many association](has-and-belongs-to-many-association.md)
  - [has_many :through association](has-many-through-association.md)

### Sections

[Base](base.md)

- [List](list.md)
- [Show](show.md)
- [Export](export.md)
- [Edit](edit.md)
  - [Create](create.md)
  - [Update](update.md)
  - [Nested](nested.md)
  - [Modal](modal.md)

### User integration

- [Authentication](authentication.md)
- [Authorization](authorization.md)
- [Mass-assignments protection](mass-assignments-protection.md)
- [Auditing changes](auditing.md)

### Extend RailsAdmin (RailsAdmin API)

- [Theming and customization](theming-and-customization.md)
- [Custom action](custom-action.md)
- [Custom field](custom-field.md)

### Styling

- [List view table styling](list-view-table-styling.md)
- [Horizontally scrolling table with frozen columns in list view](horizontally-scrolling-table-with-frozen-columns-in-list-view.md)

### Routing

- [Routing Problems](routing-problems.md)
- [Using RailsAdmin routes](using-railsadmin-routes.md)

### Recipes

- [How to set default values](how-to-set-default-values.md)
- [Excluding RailsAdmin from NewRelic](excluding-railsadmin-from-newrelic.md) For when you don't want timing and performance information about RailsAdmin to show up in your NewRelic dashboards.
- [Performance](performance.md) - how to make Rails Admin snappier with large databases
- [Changing locale](changing-locale.md).

### Plugins

#### Authorization/Auditing

- [RailsAdminAuthorizedFields](https://github.com/xronos-i-am/rails_admin_authorized_fields): Simplified authorization rules for models' fields in rails_admin
- [RailsAdminHisteroid](https://github.com/franc/rails_admin_histeroid): Mongoid 3.1 history audit support
- [RailsAdminHistoryRollback](https://github.com/rikkipitt/rails_admin_history_rollback): PaperTrail history rollback
- [RailsAdminPundit](https://github.com/sudosu/rails_admin_pundit): Integration with Pundit authorization system (this gem is for users of Pundit 1.x - the Pundit 2.x API has built-in support in RailsAdmin)

#### Field extension

- [Enumerize](https://github.com/brainspec/enumerize): Enumerated attributes with I18n and ActiveRecord/Mongoid support
- [RailsAdminActiontext](https://github.com/jemcode/rails_admin_actiontext): Rails 6 ActionText (Trix editor) support
- [RailsAdminCharts](https://github.com/pgeraghty/rails_admin_charts): Charts using Highcharts
- [RailsAdminDynamicCharts](https://github.com/openjaf/rails_admin_dynamic_charts): Dynamic Charts
- [RailsAdminGlobalizeField](https://github.com/scarfaceDeb/rails_admin_globalize_field): Tabbed interface and custom field type for globalize3 translations
- [RailsAdminJcrop](https://github.com/janx/rails_admin_jcrop): Image cropping with rails_admin_jcrop
- [RailsAdminMapField](https://github.com/trademobile/rails_admin_map_field): Coordinates with Google Maps
- [RailsAdminGoogleMap](https://github.com/nicovak/rails_admin_google_map): Google Maps integration
- [RailsAdminMongoidGeospatialField](https://github.com/sudosu/rails_admin_mongoid_geospatial_field): Support for setting geospatial information with Google Maps into Mongoid's GEO2D field
- [RailsAdminMongoidLocalizeField](https://github.com/sudosu/rails_admin_mongoid_localize_field): Support for mongoid localized fields
- [RailsAdminNestable](https://github.com/dalpo/rails_admin_nestable): Drag and drop tree view for Ancestry gem
- [RailsAdminNestedSet](https://github.com/rs-pro/rails_admin_nested_set): Drag and drop tree view for Awesome Nested Set / mongoid nested set
- [RailsAdminPlaceField](https://github.com/thinkclay/rails_admin_place_field): Google Maps with Places and Foursquare Venues
- [RailsAdminRedactor](https://github.com/anarchocurious/rails-admin-redactor): Adds support for the [Redactor](http://imperavi.com/redactor/) wysiwyg editor
- [RailsAdminTagList](https://github.com/kryzhovnik/rails_admin_tag_list): ActsAsTaggableOn tag_list field (DEPRECATED)
- [RailsUploader](https://github.com/glebtv/rails-uploader): Nice mass file uploads with jQuery File Upload for rails_admin and mongoid
- [Rich](https://github.com/bastiaanterhorst/rich): an opinionated CKEditor implementation with file uploads
- [RailsAdminCountries](https://github.com/xronos-i-am/rails_admin_countries): Add [countries](https://github.com/hexorx/countries) gem support
- [RailsAdminDropzone](https://github.com/luizpicolo/rails_admin_dropzone): Easy to use integration of drag and drop files upload via [dropzone.js](http://www.dropzonejs.com) for rails_admin
- [RailsAdminContentBuilder](https://github.com/luizpicolo/rails_admin_content_builder): Easy way for create contents using rails_admin

#### Custom action

- [RailsAdminClone](https://github.com/dalpo/rails_admin_clone): Clone records
- [RailsAdminImport](https://github.com/stephskardal/rails_admin_import): Import data from a CSV or JSON file
- [RailsAdminState](https://github.com/rs-pro/rails_admin_state): Manage state_machine states with rails_admin
- [RailsAdminAasm](https://github.com/zcpdog/rails_admin_aasm): Manage aasm states with rails_admin
- [RailsAdminToggleable](https://github.com/rs-pro/rails_admin_toggleable): Toggle boolean fields in index view
- [RailsAdminSelectable](https://github.com/jesson/rails_admin_selectable): Select value in association fields on index view (Beta)

#### Misc.

- [RailsAdminSettings](https://github.com/rs-pro/rails_admin_settings): Application setting for rails_admin and mongoid
- [RailsAdminGrid](https://github.com/colavitam/rails_admin_grid): Custom collection (index) action that displays objects in a grid with thumbnails
- [RailsAdminLiveEdit](https://github.com/blocknotes/rails_admin_live_edit): A plugin which allow to edit site content from the frontend (showing Rails Admin views in dialogs)
- [RailsAdminMydash](https://github.com/blocknotes/rails_admin_mydash): An alternative version of the dashboard with admin messages and the ability to access to Google Analytics data
