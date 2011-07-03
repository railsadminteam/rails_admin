RailsAdmin
==========
RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.

See the demo here: http://demo.railsadmin.org/

RailsAdmin started as a port of [MerbAdmin](https://github.com/sferik/merb-admin) to Rails 3
and was implemented as a [Ruby Summer of Code project](http://www.rubysoc.org/projects)
by [Bogdan Gaza](https://github.com/hurrycane) with mentors [Erik Michaels-Ober](https://github.com/sferik),
[Yehuda Katz](https://github.com/wycats),
[Luke van der Hoeven](https://github.com/plukevdh), and [Rein Henrichs](https://github.com/reinh).

It currently offers the following features:

* Display database tables
* Create new data
* Easily update data
* Safely delete data
* Automatic form validation
* Search and filtering
* Export data to CSV/JSON/XML
* Authentication (via [Devise](https://github.com/plataformatec/devise))
* User action history

Supported ORMs:

* ActiveRecord

_[Information](https://github.com/sferik/rails_admin/issues/105) about support for other ORMs._
We plan to support Mongoid soon.

Help
----
If you have a question, you can ask the [official RailsAdmin mailing list](http://groups.google.com/group/rails_admin)
or ping sferik on IRC in [#railsadmin on irc.freenode.net](http://webchat.freenode.net/?channels=railsadmin).
Please don't use the issue tracker, which is for issues only.

Check if the build is green here: http://ci.railsadmin.org/job/RailsAdmin/

If you have good reasons to think you found a *rails_admin* bug, submit a ticket providing link to gists with:

1. used rails_admin commit (in your Gemfile.lock)
2. obtained stacktrace
3. your initializers/rails_admin.rb
4. models declarations that matter
5. and anything else you find relevant

API Update Note
---------------
`navigation.max_visible_tabs` is not configurable anymore, as the new Activo
theme implements the main navigation as a vertical list.

`object_label` is not directly configurable anymore, as it lead to performance issues when used with a list of records.
Please use object_label_method instead.

The ability to set model labels for each section (list, navigation, update, ...) has been removed,
as it was deemed unnecessarily granular and was not fully honored in all displays.
That also means that the methods `label_for_navigation`, etc. are no longer functional. They print a warning at the moment.
See details in the examples below for the currently supported way to label models.
This change was motivated by the conversation following a [bug report](https://github.com/sferik/rails_admin/issues/319/#issue/319/comment/875868)
about label display errors.

The ability to set model visibility for each section has been removed due to
same reasons as section specific label configuration (see above paragraph).
This also means that methods such as `hide_from_navigation` and `show_in_list`
are no longer functional and have been deprecated. For now on use model level
configuration of visibility or for more granular control integrate an
authorization framework as outlined later in this document.

Screenshots
-----------
![Dashboard view](https://github.com/sferik/rails_admin/raw/master/screenshots/dashboard.png "Dashboard view")
![List view](https://github.com/sferik/rails_admin/raw/master/screenshots/list.png "List view")
![Edit view](https://github.com/sferik/rails_admin/raw/master/screenshots/edit.png "Edit view")

Installation
------------
In your `Gemfile`, add the following dependencies:

    gem 'devise' # Devise must be required before RailsAdmin
    gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

Run:

    $ bundle install

And then run:

    $ rake rails_admin:install

This task will install RailsAdmin and [Devise](https://github.com/plataformatec/devise) if you
don't already have it installed. [Devise](https://github.com/plataformatec/devise) is strongly
recommended to protect your data from anonymous users.

If you plan to use Devise, but want to use a custom model for authentication
(default is User) you can provide that as an argument for the installer. For example
to override the default with a Member model run:

    $ rake rails_admin:install model_name=member

If you want to use the CKEditor, you need to [download it](http://ckeditor.com/download) from source
and unpack the 'ckeditor' folder into your default 'public/javascripts' folder. If you're using any
non-Windows system, you can try to use the automatic downloader:

    $ rake rails_admin:ckeditor_download

Usage
-----
Start the server:

    $ rails server

You should now be able to administer your site at
[http://localhost:3000/admin](http://localhost:3000/admin).

Configuration
-------------
RailsAdmin provides its out of the box administrative interface by inspecting your application's
models and following some Rails conventions. For a more tailored experience, it also provides a
configuration DSL which allows you to customize many aspects of the interface.

The configuration code should be placed in an initializer file, for example:

    config/initializers/rails_admin.rb


### General

You can customize authentication by providing a custom block for `RailsAdmin.authenticate_with`.
To disable authentication, pass an empty block:

    RailsAdmin.authenticate_with {}

You can exclude models from RailsAdmin by appending those models to `excluded_models`:

    RailsAdmin.config do |config|
      config.excluded_models << ClassName
    end

**Whitelist Approach**

By default, RailsAdmin automatically discovers all the models in the system and adds them to its list of models to
be accessible through RailsAdmin. The `excluded_models` configuration above permits the blacklisting of individual model classes.

If you prefer a whitelist approach, then you can use the `included_models` configuration option instead:

    RailsAdmin.config do |config|
      config.included_models = [Class1, Class2, Class3]
    end

Only the models explicitly listed will be put under RailsAdmin access, and the auto-discovery of models is skipped.

The blacklist is effective on top of that, still, so that if you also have:

    RailsAdmin.config do |config|
      config.excluded_models = [Class1]
    end

then only `Class2` and `Class3` would be made available to RailsAdmin.

The whitelist approach may be useful if RailsAdmin is used only for a part of the application and you want to make
sure that new models are not automatically added to RailsAdmin, e.g. because of security concerns.

### Model Class and Instance Labels ###

**Setting the model's label**

If you need to customize the label of the model, use:

    RailsAdmin.config do |config|
      config.model Team do
        label "List of teams"
      end
    end

This label will be used anywhere the model name is shown, e.g. on the navigation tabs,
Dashboard page, list pages, etc.

**The object_label_method method**

The model configuration has another option `object_label_method` which configures
the title display of a single database record, i.e. an instance of a model.

By default it tries to call "name" or "title" methods on the record in question. If the object responds to neither,
then the label will be constructed from the model's classname appended with its
database identifier. You can add label methods (or replace the default [:name, :title]) with:

    RailsAdmin.config {|c| c.label_methods << :description}

This `object_label_method` value is used in a number of places in RailsAdmin--for instance for the
output of belongs to associations in the listing views of related models, for
the option labels of the relational fields' input widgets in the edit views of
related models and for part of the audit information stored in the history
records--so keep in mind that this configuration option has widespread
effects.

    RailsAdmin.config do |config|
      config.model Team do
        object_label_method do
          :custom_label_method
        end
      end
    end

    def Team<ActiveRecord::Base
      def custom_label_method
        "Team #{self.name}"
      end
    end

*Difference between `label` and `object_label`*

`label` and `object_label` are both model configuration options. `label` is used
whenever Rails Admin refers to a model class, while `object_label` is used whenever
Rails Admin refers to an instance of a model class (representing a single database record).


### Navigation ###

* hiding a model
* setting the model's label
* configuring the number of visible tabs

**Hiding a model**

You can hide a model from the top navigation by marking its `visible` option
as false:

By passing the value as an argument:

    RailsAdmin.config do |config|
      config.model Team do
        visible false
      end
    end

Or by passing a block that will be lazy evaluated each time the option is read:

    RailsAdmin.config do |config|
      config.model Team do
        visible { false }
      end
    end

These two examples also work as a generic example of how most of the
configuration options function within RailsAdmin. You can pass a value as an
argument `option_name value`, or you can pass in a block which will be
evaluated each time the option is read. Notable is that boolean options' reader
accessors will be appended with ? whereas the writers will not be. That is, if
you want to get the Team model's visibility, you use
`RailsAdmin.config(Team).visible?`.

**Create a dropdown menu in navigation**

This will desactivate config.navigation.max_visible_tabs.

    RailsAdmin.config do |config|
      ..
      config.model Team do
        parent League
      end
      config.model Division do
        parent League
      end
      ..
    end

Obtained navigation:

    Dashboard
    ...
    League # (non-clickable)
      League
      Division
      Team
    ...

You probably want to change the name of the dropdown.
This can be easily achieved with the 'dropdown' attribute of the parent model.

Added to previous example:

    RailsAdmin.config do |config|
      ...
      config.model League do
        dropdown 'League related'
      end
      ...
    end

Obtained navigation:

    Dashboard
    ...
    League related  # (non-clickable)
      League
      Division
      Team
    ...

**Change models order in navigation**

By default, they are ordered by alphabetical order. If you need to override this, specify
a weight attribute. Default is 0. Lower values will bubble items to the left, higher values
will move them to the right. Items with same weight will still be ordered by alphabetical order.
The mecanism is fully compatible with dropdown menus. Items will be ordered within their own
menu subset. (but parent will always be first inside his submenu).

Example:

    RailsAdmin.config do |config|
      config.model League do
        dropdown 'League related'
        weight -1
      end
    end

The 'League related' dropdown menu will move to the leftmost position.


### List view ###

* Number of items per page
* Number of items per page per model
* Default sorting
  * Configure globally
  * Configure per model
* Fields
  * Visibility and ordering
  * Label
  * Output formatting
  * Sortability
  * Column CSS class
  * Column width

**Number of items per page**

You can configure the default number of rows rendered per page:

    RailsAdmin.config do |config|
      config.list.default_items_per_page = 50
    end

**Number of items per page per model**

You can also configure it per model:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          items_per_page 100
        end
      end
    end

**Default sorting**

By default, rows sorted by the field `id` in reverse order

You can change default behavior with use two options: `sort_by` and `sort_reverse?`

**Default sorting - Configure globally**

    RailsAdmin.config do |config|
      config.models do
        list do
          sort_by :updated_at
          sort_reverse true # already default for serials ids and dates
        end
      end
    end

**Default sorting - Configure per model**

    RailsAdmin.config do |config|
      config.model Player do
        list do
          sort_by :name
          sort_reverse false
        end
      end
    end

**Fields - Sortability**

You can make a column non-sortable by setting the sortable option to false (1)
You can change the column that the field will actually sort on (2)
Belongs_to associations :
  will be sorted on their label if label is not virtual (:name, :title, etc.)
  otherwise on the foreign_key (:team_id)
  you can also specify a column on the targetted table (see example) (3)


    RailsAdmin.config do |config|
      config.model Player do
        list do
          field :created_at do # (1)
            sortable false
          end
          field :name do # (2)
            sortable :last_name # imagine there is a :last_name column and that :name is virtual
          end
          field :team_id do # (3)
            sortable :win_percentage
            # Will order by players playing with the best teams,
            # rather than the team name (by default),
            # or the team id (dull but default if label is not a column name)
          end
        end
      end
    end

Default sort column is :id for ActiveRecord version
To change it:
    RailsAdmin.config do |config|
      config.model Team do
        sort_by :nam
      end
    end

By default, dates and serial ids are reversed when first-sorted ('desc' instead of 'asc' in SQL).
If you want to reverse (or cancel it) the default sort order (first column click or the default sort column):

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :id do
            sort_reverse? false   # will sort id increasing ('asc') first ones first (default is last ones first)
          end
          field :created_at do
            sort_reverse? false   # will sort dates increasing ('asc') first ones first (default is last ones first)
          end
          field :name do
            sort_reverse? true    # will sort name decreasing ('dec') z->a (default is a->z)
          end
        end
      end
    end

**Fields - Searchability**

You can make a column non-searchable by setting the searchable option to false (1)
You can change the column that the field will actually search on (2)
You can specify a list of column that will be searched over (3)
Belongs_to associations :
  will be searched on their foreign_key (:team_id)
  will be searched on their label if label is not virtual (:name, :title, etc.)
  you can also specify columns on the targetted table (see example) (4)

    RailsAdmin.config do |config|
      config.model Player do
        list do
          field :created_at do # (1)
            searchable false
          end

          field :name do (2)
            searchable :last_name
          end
          # OR
          field :name do (3)
            searchable [:first_name, :last_name]
          end

          field :team_id do # (4)
            searchable [:name, :id]
            # eq. to [{Team => :name}, {Team => :id}]
            # or even [:name, {Player => :team_id}]
          end
        end
      end
    end

Searchable definitions will be used for searches and filters.
You can independently desactivate querying (search) or filtering for each field with:

    field :team do
      searchable [:name, :color]
      queryable? true # default
      filterable? false
    end

**Fields - Visibility and ordering**

By default all fields are visible, but they are not presented in any particular
order. If you specifically declare fields, only defined fields will be visible
and they will be presented in the order defined:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name
          field :created_at
        end
      end
    end

This would show only "name" and "created at" columns in the list view.

If you need to hide fields based on some logic on runtime (for instance
authorization to view field) you can pass a block for the `visible` option
(including its `hide` and `show` accessors):

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name
          field :created_at
          field :revenue do
            visible do
              current_user.roles.include?(:accounting) # metacode
            end
          end
        end
      end
    end

Note that above example's authorization conditional is not runnable code, just
an imaginary example. You need to provide RailsAdmin with your own
authorization scheme for which you can find a guide at the end of this file.

**Fields - Label**

The header of a list view column can be changed with the familiar label method:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name do
            label "Title"
          end
          field :created_at do
            label "Created on"
          end
        end
      end
    end

As in the previous example this would show only columns for fields "name" and
"created at" and their headers would have been renamed to "Title" and
"Created on".

**Fields - Output formatting**

The field's output can be modified:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name do
            formatted_value do
              value.to_s.upcase
            end
          end
          field :created_at
        end
      end
    end

This would render all the teams' names uppercased.

The field declarations also have access to a bindings hash which contains the
current record instance in key :object and the view instance in key :view.
Via :object we can access other columns' values and via :view we can access our
application's view helpers:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name do
            formatted_value do
              bindings[:view].tag(:img, { :src => bindings[:object].logo_url }) << value
            end
          end
          field :created_at
        end
      end
    end

This would output the name column prepended with team's logo using the `tag`
view helper. This example uses `value` method to access the name field's value,
but that could be written more verbosely as `bindings[:object].name`.

Fields of different date types (date, datetime, time, timestamp) have two extra
options to set the time formatting:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name
          field :created_at do
            date_format :short
          end
          field :updated_at do
            strftime_format "%Y-%m-%d"
          end
        end
      end
    end

This would render all the teams' "created at" dates in the short format of your
application's locale and "updated at" dates in format YYYY-MM-DD. If both
options are defined for a single field, `strftime_format` has precedence over
`date_format` option. For more information about localizing Rails see
[Rails Internationalization API](http://edgeguides.rubyonrails.org/i18n.html#adding-date-time-formats)
and [Rails I18n repository](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale).

**Fields - Column CSS class**

By default each column has a CSS class set according to field's data type. You
can customize this by:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name
          field :created_at do
            css_class "customClass"
          end
        end
      end
    end

This would render the "created at" field's header and body columns with a CSS class named
"customClass".

**Fields - Column width**

By default columns' widths are calculated from certain pre-defined,
data-type-specific pixel values. If you want to ensure a minimum width for a
column, you can:

    RailsAdmin.config do |config|
      config.model Team do
        list do
          field :name do
            column_width 200
          end
          field :created_at
        end
      end
    end

### Create and update views

* Form rendering
* Field groupings
  * Visibility
  * Labels
  * Syntax
* Fields
  * Rendering
  * Overriding field type
  * Available field types
  * Creating a custom field type
  * Creating a custom field factory
  * Overriding field help texts
  * CKEditor integration

**Form rendering**

RailsAdmin renders these views with Rails' form builder (form_for). If you want to use a different
form builder then provide an override for the edit view or independingly for the
create and update views. The argument is a symbol or string that is sent to the view
to process the form. This is handy for integrating things like the nested form builder (https://github.com/ryanb/nested_form) if you need to override a field's edit template.

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          form_builder :nested_form_for
          field :name
        end
      end
    end

or independently

    RailsAdmin.config do |config|
      config.model Team do
        create do
          form_builder :create_form_for
          field :name
        end
        update do
          form_builder :update_form_for
          field :name
        end
      end
    end

**Field groupings**

By default RailsAdmin groups fields in the edit views (create and update views)
by including all database columns and belongs to associations to "Basic info"
group which is displayed on top of form. Below that are displayed all the other
associations a model has, one group per association.

The configuration accessors are `edit`, `create` and `update`. First one is a
batch accessor which configures both create and update views. For consistency,
these examples only include the batch accessor `edit`, but if you need differing
create and update views just replace `edit` with `create` or `update`.

**Field groupings - visibility**

Field groups can be hidden:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          group :default do
            hide
          end
        end
      end
    end

This would hide the "Basic info" group which is accessed by the symbol :default.
Associations' groups can be accessed by the name of the association, such as
:fans or :players. The hide method is just a shortcut for the actual `visible`
option which was mentioned in the beginning of the navigation section.

**Field groupings - labels**

Field groups can be renamed:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          group :default do
            label "Team information"
          end
        end
      end
    end

This would render "Team information" instead of "Basic info" as the groups label.

**Field groupings - help**

Field groups can have a set of instructions which is displayed under the label:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          group :default do
            label "Team information"
            help "Please fill all informations related to your team..."
          end
        end
      end
    end

This content is mostly useful when the admin doign the data entry is not familiar with the system or as a way to display inline documentation.


**Field groupings - syntax**

As in the list view, the edit views' configuration blocks can directly
contain field configurations, but in edit views those configurations can
also be nested within group configurations. Below examples result an
equal configuration:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          group :default do
            label "Default group"
          end
          field :name do
            label "Title"
            group :default
          end
        end
      end
    end

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          group :default do
            label "Default group"
            field :name do
              label "Title"
            end
          end
        end
      end
    end

In fact the first examples `group :default` configuration is unnecessary
as the default group has already initialized all fields and belongs to
associations for itself.

**Fields**

Just like in the list view, all fields are visible by default. If you specifically
declare fields, only defined fields will be visible and they will be presented
in the order defined. Thus both examples would render a form with
only one group (labeled "Default group") that would contain only one
element (labeled "Title").

In the list view label is the text displayed in the field's column header, but
in the edit views label literally means the html label element associated with
field's input element.

Naturally edit views' fields also have the visible option along with
hide and show accessors as the list view has.

**Fields - rendering**

The edit view's fields are rendered using partials. Each field type has its own
partial per default, but that can be overridden:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :name do
            partial "my_awesome_partial"
          end
        end
      end
    end

The partial should be placed in your applications template folder, such as
`app/views/rails_admin/main/_my_awesome_partial.html.erb`.

One can also completely override the rendering logic:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :name do
            render do
              bindings[:view].render :partial => partial.to_s, :locals => {:field => self}
            end
          end
        end
      end
    end

That example is just the default rendering method, but it shows you that you
have access to the current template's scope with bindings[:view]. There's also
bindings[:object] available, which is the database record being edited.
Bindings concept was introduced earlier in this document and the
functionality is the same.

**Fields - overriding field type**

If you'd like to override the type of the field that gets instantiated, the
field method provides second parameter which is field type as a symbol. For
instance, if we have a column that's a text column in the database, but we'd
like to have it as a string type we could accomplish that like this:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :description, :string do
             # configuration here
          end
        end
      end
    end

If no configuration needs to take place the configuration block could have been
left out:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :description, :string
        end
      end
    end

A word of warning, if you make field declarations for the same field a number
of times with a type defining second argument in place, the type definition
will ditch the old field configuration and load a new field instance in place.

**Fields - Available field types**

RailsAdmin ships with the following field types:

* belongs_to_association
* boolean
* date
* datetime
* decimal
* file_upload _does not initialize automatically_
* paperclip_file _initializes automatically if Paperclip is present_
* float
* has_and_belongs_to_many_association
* has_many_association
* has_one_association
* integer
* password _initializes if string type column's name is password_
* string
* enum
* text
* time
* timestamp
* virtual _useful for displaying data that is calculated a runtime
(for example a method call on model instance)_

**Fields - Creating a custom field type**

If you have a reusable field you can define a custom class extending
`RailsAdmin::Config::Fields::Base` and register it for RailsAdmin:

    RailsAdmin::Config::Fields::Types::register(:my_awesome_type, MyAwesomeFieldClass)

Then you can use your custom class in a field:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :name, :my_awesome_type do
             # configuration here
          end
        end
      end
    end

**Fields - Creating a custom field factory**

Type guessing can be overridden by registering a custom field "factory", but
for now you need to study `lib/rails_admin/config/fields/factories/*` for
examples if you want to use that mechanism.

**Fields - Overriding field help texts**

Every field is accompanied by a hint/text help based on model's validations.
Everything can be overridden with `help`:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :name
          field :email do
            help 'Required - popular webmail addresses not allowed'
          end
        end
      end
    end

**Fields - Paperclip**

    class Team < ActiveRecord::Base
      has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

      # handling delete in your model, if needed. Replace all image occurences with your asset name.
      attr_accessor :delete_image
      before_save { self.image = nil if self.delete_image == '1' }
    end

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :image do
            thumb_method :thumb # for images. Will default to full size image, which might break the layout
            delete_method :delete_image # actually not needed in this case: default is "delete_#{field_name}" if the object responds to it
          end
        end
      end
    end

**Fields - Enum**

Fields of datatype string, integer, text can be rendered with select boxes. Auto-detected if object responds to `#{method_name}_enum`.
You can use `enum_method` to indicate the name of the enumeration method in your model.
You can use `enum` to override any `enum_method` and give back a `FormOptionsHelper#options_for_select` collection.

    class Team < ActiveRecord::Base
      ...
      def color_enum
        [['blue', 'red'], 'red']
        # should return any collection accepted by `FormOptionsHelper#options_for_select`
        # See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-options_for_select
      end
      ...
    end

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :color
          # defaults to
          # field :color, :enum do
          #   enum_method do
          #     :color_enum
          #   end
          # end
        end
      end
    end

If you don't have any enumeration method in your model, this will work:

    RailsAdmin.config do |config|
      config.model Team do
        edit do
          field :color, :enum do
            enum do
              ['green', 'white']
            end
          end
        end
      end
    end

**Fields - CKEditor integration**

CKEditor can be enabled on fields of type text:

    RailsAdmin.config do |config|
      config.model MyModel do
        edit do
          field :description, :text do
            ckeditor true
          end
        end
      end
    end

**Fields - Ordered has_many/has_and_belongs_to_many/has_many :through associations**

Orderable can be enabled on filtering multiselect fields (has_many, has_many :through & has_and_belongs_to_many associations), allowing selected options to be moved up/down.
RailsAdmin will handle ordering in and out of the form.

    RailsAdmin.config do |config|
      config.model Player do
        edit do
          field :fans do
            orderable true
          end
        end
      end
    end

You'll need to handle ordering in your model with a position column for example.


### Configuring fields ###

* exclude_fields field_list
* exclude_fields_if cond
* include_fields field_list
* include_fields_if cond
* include_all_fields
* fields field_list,  configuration_block


** Fields - exclude some fields **

By default *all* fields found on your model will be added to list/edit/export views,
with a few exceptions for polymorphic columns and such.
You can exclude specific fields with exclude_fields & exclude_fields_if:

Example:

    RailsAdmin.config do |config|
      config.model League do
        list do
          exclude_fields_if do
            type == :datetime
          end

          exclude_fields :id, :name     
        end
      end
    end

But after you specify your *first* field, this behaviour will be canceled.
*Only* the specified fields will be added.
But you can then use include_all_fields to add all default fields:

Example:

    RailsAdmin.config do |config|
      config.model League do
        list do
          field :name do
            # snipped specific configuration for name attribute
          end
          
          include_all_fields # all other default fields will be added after, conveniently
          exclude_fields :created_at # but you still can remove fields
        end
      end
    end

** Fields - include some fields **

It is also possible to add fields by group and configure them by batches:

Example:

    RailsAdmin.config do |config|
      config.model League do
        list do
          # all selected fields will be added, but you can't configure them. 
          # If you need to select them by type, see *fields_of_type*
          include_fields_if do
            name =~ /displayed/
          end
          
          include_fields :name, :title                # simply adding fields by their names (order will be maintained)
          fields :created_at, :updated_at do          # adding and configuring
            label do
              "#{label} (timestamp)"
            end
          end
        end
      end
    end

### Mass Assignment Operations ###

* Mass assign for every model configuration
* Mass assign for every section (create, list, navigation and update)
* Mass assign by field type

**Mass assign for every model configuration**

Mass assignment operations are used to pass in configuration blocks for
multiple targets at once. For instance, the code below configures every models'
every field with an uppercased label in the list view.

    RailsAdmin.config do |config|
      config.models do
        list do
          fields do
            label do
              label.upcase # in this context label refers to default label method
            end
          end
        end
      end
    end

**Mass assign for every section (create, list, navigation and update)**

If one would like to assign that same behavior for all the different views in
RailsAdmin (create, list, navigation and update) one could pass the label
definition one level higher:

    RailsAdmin.config do |config|
      config.models do
        fields do
          label do
            label.upcase
          end
        end
      end
    end

As the navigation section does not define the `fields` method this
configuration is only effective for create, list and update views.

Naturally this also works for a single model configuration:

    RailsAdmin.config do |config|
      config.model Team do
        fields do
          label do
            label.upcase
          end
        end
      end
    end

**Mass assign by field type**

One can also assign configurations for all fields by type. For instance
modifying the date presentation of all datetime fields in all sections can be
accomplished like this:

    RailsAdmin.config do |config|
      config.models do
        fields_of_type :datetime do
          strftime_format "%Y-%m-%d"
        end
      end
    end

Or even scope it like this:

    RailsAdmin.config do |config|
      config.models do
        list do
          fields_of_type :datetime do
            date_format :compact
          end
        end
      end
    end

Authorization
-------------

Authorization can be added using the `authorize_with` method. If you pass a block
it will be triggered through a before filter on every action in Rails Admin.

    RailsAdmin.authorize_with do
      redirect_to root_path unless warden.user.is_admin?
    end

To use an authorization adapter, pass the name of the adapter. For example, to use
with [CanCan](https://github.com/ryanb/cancan), pass it like this.

    RailsAdmin.authorize_with :cancan

See the [wiki](https://github.com/sferik/rails_admin/wiki) for more on authorization.

Static Assets & Locales
-----------------------

When running `rake rails_admin:install` the locale files (`config/locales/...`) and the static asset files
(javascript files, images, stylesheets) are copied to your local application tree.

Should you update the gem to a new version that perhaps includes updated locale or asset files, then you won't automatically
be able to take advantage of these. In fact, you may choose for this reason, to not commit locale files and asset
files to your local repository and instead have them loaded from the gem.

You can choose to commit locale files to your local application tree, if you want to modify them from what the gem
supplies; then you also need to manage updates by hand. Locale files will be automatically loaded from the gem
unless overrides exist.

For asset files, the following applies: When running in development mode, the rails_admin engine will inject a middleware
to serve static assets (javascript files, images, stylesheets) from the gem's location. This generally isn't a good
setup for high-traffic production environments. Depending on your web server configuration is may also just plain fail.
You may need to serve the asset files from the local application tree (public/...). You can choose to have the assets
served from the gem in development mode but from the local application tree in production mode. In that case, you
need to copy the assets during deployment (e.g. via a capistrano hook).

Two rake tasks have been provided to copy locale and asset files to the local application tree:

    rake rails_admin:copy_locales
    rake rails_admin:copy_assets

These tasks run automatically during installation, but are provided separately, e.g. for updates or deployments.

Contributing
------------
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by [translating to a new language](https://github.com/sferik/rails_admin/tree/master/config/locales)
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/sferik/rails_admin/issues)
* by reviewing patches

Submitting an Issue
-------------------
We use the [GitHub issue tracker](https://github.com/sferik/rails_admin/issues) to track bugs and
features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issue by voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.  *NOTE* - there's a small test app located in the spec/dummy_app directory that you can use to experiment with rails_admin.
4. Add documentation for your feature or bug fix.
5. Run `bundle exec rake doc:yard`. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run `bundle exec rake spec`. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)

Contact
-------
If you have questions about contributing to RailsAdmin, please contact [Erik Michaels-Ober](https://github.com/sferik) and [Bogdan Gaza](https://github.com/hurrycane).
