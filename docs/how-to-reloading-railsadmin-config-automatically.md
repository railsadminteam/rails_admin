## Automatically reload rails_admin configuration when in development mode

In your `/config/initializers/rails_admin.rb` you should add:

```ruby
config.parent_controller = ApplicationController.to_s
```

And then in `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :reload_rails_admin, if: :rails_admin_path?

  private

  def reload_rails_admin
    models = %W(User UserProfile)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env.development?
  end

end
```

This will clear any RailsAdmin configuration in the individual model files. Use it only if you do all your configuration in `rails_admin.rb`.

[rails_admin_import](https://github.com/stephskardal/rails_admin_import) gem will not work if you add the above code.

## Automatic Model List

#### To avoid having to maintain a list of models manually you can extend your ORM to collect them upon initialization.

```ruby
# config/initializers/mongoid.rb
module Mongoid::Document
  @@models = []

  def self.included base
    @@models << base
  end

  def self.models
    @@models
  end
end
```

```ruby
# config/initializers/active_record.rb
class ActiveRecord::Base
  @@models = []

  def self.inherited sub_class
    @@models << sub_class
  end

  def self.models
    @@models
  end
end
```

Then instead of `%W(User UserProfile)` you can do `Mongoid::Document.models` or `ActiveRecord::Base.models`

If the above throws the following error when accessing an index page while using ActiveRecord :

    undefined method `page' for #<ActiveRecord::Relation>

then delete `config/initializer/active_record.rb` and replace the model loading in the controller (the first line of `reload_rails_admin`) with :

    models = ActiveRecord::Base.descendants

When using Rails 3/4:

If `config.cache_classes = false` (by default it's off in development, but on in production) enable your applications eager loading.

```ruby
Rails.application.configure do
  config.eager_load = true
```

or

```
Rails.application.eager_load!
```

## Alternative method for the RailsAdmin versions that does not extend ApplicationController

Create an initializer file named : rails_admin_reload.rb

```ruby
Rails.application.config.to_prepare do
  RailsAdmin::ApplicationController.class_eval do
    before_action :reload_rails_admin, if: :reload_rails_admin? # Reloading RailsAdmin Config Automatically

    def reload_rails_admin
      RailsAdmin::Config.reset

      # Use this if you have a single RailsAdmin configuration file (default)
      load("#{Rails.root}/config/initializers/rails_admin.rb")

      # Use this if you have a folder with your RailsAdmin configuration files inside, or comment if not
      Dir.foreach("#{Rails.root}/config/initializers/rails_admin") do |item|
        next if item == '.' or item == '..'
        load("#{Rails.root}/config/initializers/rails_admin/#{item}")
      end
    end

    def reload_rails_admin?
      Rails.env.development?
    end
  end
end
```

## Less Desirable Method ("Dirty" just sounds so... dirty.)

#### Move your RailsAdmin.config block into the app controller for dynamic reloading of changes in dev, etc

#### Then stare at the various examples below...

```ruby
class ApplicationController < ActionController::Base
    protect_from_forgery

    helper RailsAdmin::Engine.helpers

    before_filter :rails_admin_dynamic_config

    def rails_admin_dynamic_config

        model_list = [ TestScenario, TestCase, TestScript, TestBlock, TestScenarioExecute, TestSeleniumUpload, TestRunResult, QaBamTask, MdmProduct, MdmProductFamily, MdmProductFeature, MdmProductLine, MdmProductSection, MdmStatus, User ]

        model_list.each do |m|
            RailsAdmin::Config.reset_model( m )
        end

        RailsAdmin.config do |config|

            config.default_items_per_page = 25
            config.total_columns_width = 1000

            # LIST TestScenario
            config.model TestScenario do
                list do
                    sort_by :name
                    field :name do
                        formatted_value do
                            bindings[:view].content_tag(:a, "#{bindings[:object].name}" , :href => "/qabam/app/test_scenario/#{bindings[:object].id}/edit")
                        end
                    end
                    field :mdm_status do
                        sortable :position
                        label "STATUS"
                        pretty_value do
                            bindings[:view].content_tag(:span, value.name )
                        end
                    end
                    field :mdm_priority do
                        label "PRIORITY"
                        pretty_value do
                            bindings[:view].content_tag(:span, value.name )
                        end
                    end
                end
            end

            # LIST TestCase
            config.model TestCase do
                list do
                    #columns_width = 15
                    sort_by :case_number
                    sort_reverse false
                    #filters [:test_scenario, :case_number, :mdm_status]
                    field :case_number do
                        label "CASE NUMBER"
                        searchable :case_number
                        formatted_value do
                            bindings[:view].content_tag(:a, "#{bindings[:object].case_number}" , :href => "/qabam/app/test_case/#{bindings[:object].id}/edit")
                        end
                    end
                    field :test_scenario do
                        label "TEST SCENARIO"
                        pretty_value do
                            bindings[:view].content_tag(:span, value.name )
                        end
                    end
                    field :mdm_status do
                        sortable :position
                        label "STATUS"
                        pretty_value do
                            bindings[:view].content_tag(:span, value.name )
                        end
                    end
                end
            end

            # LIST TestScript
            config.model TestScript do
                list do
                    sort_by :test_case_java_class_method
                    field :test_case_java_class_method do
                        label "TEST SUITE JAVA METHOD NAME"
                        formatted_value do
                            bindings[:view].content_tag(:a, "#{bindings[:object].test_case_java_class_method}" , :href => "/qabam/app/test_script/#{bindings[:object].id}/edit")
                        end
                    end
                    field :mdm_status do
                        sortable :position
                        label "STATUS"
                        pretty_value do
                            bindings[:view].content_tag(:span, value.name )
                        end
                    end
                end
            end

            # BULK Adjust labels
            config.models do
                fields do
                    label do
                        label.sub!('Mdm ', '') if label.include? ('Mdm ')
                        if label.include? ('hours')
                            label.sub!(' hours', '')
                            help 'In hours.'
                        end
                        if label.include? ('minutes')
                            label.sub!(' minutes', '')
                            help 'In minutes.'
                        end
                        label.upcase
                    end
                end
            end

            # CORE TestScenario
            config.model TestScenario do
                label 'Scenario'
                navigation_label "Tests"
                weight 0
                configure :test_suite_java_class_base do
                    label "TEST SUITE JAVA CLASS BASE NAME"
                    help "Required. Example: com.taleo.monarch.automation.functionaltests.csw"
                end
                #configure :test_suite_java_svn_path do
                #    help "Path to Java Class in SVN codeline."
                #end

                # TODO scenario-actual date fields, read only, calculate based on min/max dates for cases/scripts (OR HIDE)
                # TODO scenario-jquery file path selector for java svn path
                # TODO scenario-have drop downs for product data populate dynamically based on previous field

                include_all_fields
                exclude_fields :mdm_product_line, :mdm_product_family, :test_suite_java_svn_path
                edit do
                    field :name do
                        label "TEST SCENARIO NAME"
                    end
                    field :test_suite_java_class_base
                    #field :test_suite_java_svn_path
                    field :summary
                    field :mdm_product
                    field :assigned_to
                    field :mdm_priority
                    field :comment
                    field :mdm_status do
                        associated_collection_cache_all false
                        associated_collection_scope do
                            Proc.new { |scope| scope = scope.where(status_type: 'Test Scenario').reorder( 'mdm_statuses.position desc, mdm_statuses.name asc' ) }
                        end
                    end
                    field :planned_start_date
                    field :planned_end_date
                    field :actual_start_date
                    field :actual_end_date
                    field :actual_effort_hours #, :decimal
                    field :date_completed
                    field :test_cases do
                        partial "child_multiselect_clearonsave"
                        help "Double-Click Items To Edit."
                        associated_collection_cache_all false
                        associated_collection_scope do
                            ts = bindings[:object]
                            Proc.new { |scope| scope = scope.where("test_cases.test_scenario_id = #{ts.id || 0} or test_cases.test_scenario_id is null") }
                        end
                        active true
                    end
                    field :test_scripts do
                        partial "child_multiselect_clearonsave"
                        help "Double-Click Items To Edit."
                        associated_collection_cache_all false
                        associated_collection_scope do
                            ts = bindings[:object]
                            Proc.new { |scope| scope = scope.where("test_scripts.test_scenario_id = #{ts.id || 0} or test_scripts.test_scenario_id is null") }
                        end
                    end
                    field :test_blocks do
                        partial "child_multiselect_clearonsave"
                        help "Double-Click Items To Edit."
                        associated_collection_cache_all false
                        associated_collection_scope do
                            ts = bindings[:object]
                            Proc.new { |scope|
                                # had to override original sql to exclude available blockers that closed....
                                scope = scope.joins( 'LEFT OUTER JOIN test_blocks_test_scenarios ON test_blocks.id = test_blocks_test_scenarios.test_block_id' )
                                scope = scope.where("test_blocks_test_scenarios.test_scenario_id = #{ts.id || 0} or test_blocks.mdm_status_id = #{MdmStatus.where( status_type: 'Test Blocker', status_state: 'open' ).first.id}" )
                                scope = scope.uniq
                            }
                        end
                        # TODO try to hide nested_forms on edit, apply to others
                    end
                    field :test_selenium_uploads do
                        partial "child_multiselect_clearonsave"
                        help "Double-Click Items To Edit."
                        associated_collection_cache_all false
                        associated_collection_scope do
                            ts = bindings[:object]
                            Proc.new { |scope| scope = scope.where("test_scenario_id = #{ts.id || 0} or test_scenario_id is null") }
                        end
                    end
                end
                create do
                    exclude_fields :test_cases, :test_scripts, :test_blocks, :test_selenium_uploads
                end
            end

            # CORE TestCase
            config.model TestCase do
                label 'Case'
                navigation_label 'Tests'
                weight 5
                # TODO case-file/url picker case requirement file
                # TODO case-hide actual effort?
                configure :case_number do
                    #label "Case Number / Java Class Name"
                    #help "(Case # = Java METHOD Name) - Required"
                end
                configure :test_case_java_class_method do
                    label "TEST CASE JAVA CLASS+METHOD NAME"
                    help "Required. Example: UITest_CSW_01_Admin.test_CSW_01"
                end
                configure :case_requirement_file_path do
                    help "Url/Path to Requirements Document for this test case."
                end
                configure :mdm_status do
                    associated_collection_cache_all false
                    associated_collection_scope do
                        Proc.new { |scope| scope = scope.where(status_type: 'Test Case').reorder( 'mdm_statuses.position desc, mdm_statuses.name asc' ) }
                    end
                end
                field :created_date
                field :closed_date
                exclude_fields :case_requirement_file_path
                field :test_blocks do
                    partial "child_multiselect_clearonsave"
                    help "Double-Click Items To Edit."
                    associated_collection_cache_all false
                    associated_collection_scope do
                        ts = bindings[:object]
                        Proc.new { |scope|
                            # had to override original sql to exclude available blockers that closed....
                            scope = scope.joins( 'LEFT OUTER JOIN test_blocks_test_cases ON test_blocks.id = test_blocks_test_cases.test_block_id' )
                            scope = scope.where("test_blocks_test_cases.test_case_id = #{ts.id || 0} or test_blocks.mdm_status_id = #{MdmStatus.where( status_type: 'Test Blocker', status_state: 'open' ).first.id}" )
                            scope = scope.uniq
                        }
                    end
                    # TODO try to hide nested_forms on edit, apply to others
                end
            end

            # CORE TestScript
            config.model TestScript do
                label 'Script'
                navigation_label "Tests"
                #parent TestScenario
                weight 10
                include_all_fields
                # TODO script-default status
                # TODO script-file picker svn java file loc
                # TODO script-allow 1 script to have many cases
                configure :test_case_java_class_method do
                    label "TEST CASE JAVA CLASS+METHOD NAME"
                    help "Required. Example: UITest_CSW_01_Admin.test_CSW_01"
                end
                configure :mdm_status do
                    associated_collection_cache_all false
                    associated_collection_scope do
                        Proc.new { |scope| scope = scope.where(status_type: 'Test Script').reorder( 'mdm_statuses.position desc, mdm_statuses.name asc' ) }
                    end
                end
                field :created_date
                field :closed_date
                exclude_fields :svn_java_file_location

                field :test_blocks do
                    partial "child_multiselect_clearonsave"
                    help "Double-Click Items To Edit."
                    associated_collection_cache_all false
                    associated_collection_scope do
                        ts = bindings[:object]
                        Proc.new { |scope|
                            # had to override original sql to exclude available blockers that closed....
                            scope = scope.joins( 'LEFT OUTER JOIN test_blocks_test_scripts ON test_blocks.id = test_blocks_test_scripts.test_block_id' )
                            scope = scope.where("test_blocks_test_scripts.test_script_id = #{ts.id || 0} or test_blocks.mdm_status_id = #{MdmStatus.where( status_type: 'Test Blocker', status_state: 'open' ).first.id}" )
                            scope = scope.uniq
                        }
                    end
                    # TODO try to hide nested_forms on edit, apply to others
                end
                create do
                    configure :test_case do
                        visible false
                    end
                end
                update do
                    configure :test_case do
                        associated_collection_scope do
                            #associated_collection_cache_all false
                            ts = bindings[:object]
                            Proc.new { |scope| scope = scope.where( test_scenario_id: ts.test_scenario_id) if ts.present?    }
                        end
                    end
                end
            end

            # CORE TestBlock
            config.model TestBlock do
                label 'Blocker'
                navigation_label "Tests"
                weight 20
                # TODO block-priority to drop-down
                configure :mdm_status do
                    associated_collection_cache_all false
                    associated_collection_scope do
                        Proc.new { |scope| scope = scope.where(status_type: 'Test Blocker').reorder( 'mdm_statuses.position desc, mdm_statuses.name asc' ) }
                    end
                end
                configure :priority, :belongs_to_association do
                    partial "form_filtering_select"
                end
                field :test_scenarios do
                    partial "child_multiselect_clearonsave"
                end
                field :test_cases do
                    partial "child_multiselect_clearonsave"
                end
                field :test_scripts do
                    partial "child_multiselect_clearonsave"
                end
            end

            # CORE TestSeleniumUpload
            config.model TestSeleniumUpload do
                label 'Upload Selenium Result'
                navigation_label "Test Results"
                #parent TestScenario
                weight 10
                #include_all_fields
                #field :xml_result, :paperclip
                # TODO script-default upload date
            end

            # CORE TestRunResult
            config.model TestRunResult do
                label 'Test Run Result'
                navigation_label "Test Results"
                weight 15
            end

            # CORE TestScenarioExecute
            config.model TestScenarioExecute do
                visible false
                label 'Execution'
                navigation_label "Test Results"
                weight 15
            end

            # CORE QaBamTask
            config.model QaBamTask do
                label 'QaBAM Task'
                navigation_label 'Chad'
                weight 850
                configure :mdm_status do
                    associated_collection_cache_all false
                    associated_collection_scope do
                        Proc.new { |scope|
                            scope = scope.where(status_type: 'QaBam Task').reorder( 'mdm_statuses.position desc, mdm_statuses.name asc' )
                        }
                    end
                end
            end

            # CORE MdmProductLine
            config.model MdmProductLine do
                label 'Product Line'
                navigation_label 'Setup'
                weight 810
            end

            # CORE MdmProductFamily
            config.model MdmProductFamily do
                label 'Product Family'
                navigation_label 'Setup'
                weight 811
            end

            # CORE MdmProduct
            config.model MdmProduct do
                label 'Product'
                visible TRUE
                navigation_label 'Setup'
                weight 812
                list do
                    sort_by :name
                end
                field :id do
                    sortable false
                end
            end

            # CORE MdmProductFeature
            config.model MdmProductFeature do
                label 'Product Feature'
                visible true
                navigation_label 'Setup'
                weight 813
                list do
                    sort_by :name
                end
                field :id do
                    sortable false
                end
            end

            # CORE MdmProductSection
            config.model MdmProductSection do
                label 'Product Section'
                visible true
                navigation_label 'Setup'
                weight 814
                list do
                    sort_by :name
                end
                field :id do
                    sortable false
                end
            end

            # CORE MdmStatus
            config.model MdmStatus do
                label 'Status'
                label_plural 'Statuses'
                navigation_label 'Setup'
                weight 850
                list do
                    sort_by :position
                end
                field :id do
                    sortable false
                end
            end

            # CORE MdmPriority
            config.model MdmPriority do
                label 'Priority'
                label_plural 'Priorities'
                navigation_label 'Setup'
                weight 850
                list do
                    sort_by :name
                end
                field :id do
                    sortable false
                end
                field :name
            end

            # CORE User
            config.model User do
                label 'User'
                weight 900
                navigation_label 'Setup'
                field :id do
                    sortable false
                end
                list do
                    sort_by :name
                    field :name do
                        formatted_value do
                            bindings[:view].content_tag(:a, "#{bindings[:object].name}" , :href => "/qabam/app/user/#{bindings[:object].id}/edit")
                        end
                    end
                    field :email do
                        sortable :position
                        label "EMAIL"
                        pretty_value do
                            bindings[:view].content_tag(:span, value )
                        end
                    end
                    field :timezone do
                        label "TIME ZONE"
                        pretty_value do
                            bindings[:view].content_tag(:span, value )
                        end
                    end
                end
                edit do
                    field :notification_email_types do
                    render do
                      bindings[:form].select( "notification_email_types", bindings[:object].notification_email_types_enum, {}, { :multiple => true })
                    end
                  end
                end
                #bindings[:controller].current_user.role == :admin
            end

            # ***************************
            # BEGIN SET USER ID's
            # TODO repair/relogic the 'nothing to see here' hack
            config.model TestScenario do
                create do
                    configure :created_by do
                        visible false
                        help ""
                    end
                    field :created_by_id, :hidden do
                        visible true
                        help ""
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    configure :mdm_priority do
                        default_value MdmPriority.where( default_priority: true ).first.id
                    end
                    configure :mdm_product do
                        default_value MdmProduct.where( name: 'Recruiting' ).first.id
                    end
                    configure :mdm_status do
                        default_value MdmStatus.where( status_type: 'Test Scenario', default_status: true ).first.id
                    end
                end
            end
            config.model TestCase do
                create do
                    configure :authored_by do
                        visible false
                        help ""
                    end
                    field :authored_by_id, :hidden do
                        visible true
                        help ""
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    configure :mdm_priority do
                        default_value MdmPriority.where( default_priority: true ).first.id
                    end
                    configure :mdm_status do
                        default_value MdmStatus.where( status_type: 'Test Case', default_status: true ).first.id
                    end
                end
            end
            config.model TestScript do
                create do
                    configure :scripted_by do
                        visible false
                        help ""
                    end
                    field :scripted_by_id, :hidden do
                        visible true
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    configure :mdm_status do
                        default_value MdmStatus.where( status_type: 'Test Script', default_status: true ).first.id
                    end
                end
            end

            config.model TestSeleniumUpload do
                create do
                    configure :uploaded_by do
                        visible false
                        help ""
                    end
                    field :uploaded_by_id, :hidden do
                        visible true
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    # TODO default date value...
                    # D:\apps\java\jruby\lib\ruby\gems\1.8\bundler\gems\rails_admin-7a4fdd931f95\app\views\rails_admin\main\_form_datetime.html.haml
                    # D:\apps\java\jruby\lib\ruby\gems\1.8\bundler\gems\rails_admin-7a4fdd931f95\app\assets\javascripts\rails_admin\ra.datetimepicker.js
                    #configure :executed_on do
                    #    value = 'March 23, 2012'
                    #end
                end
            end

            config.model TestBlock do
                create do
                    configure :created_by do
                        visible false
                        help ""
                    end
                    field :created_by_id, :hidden do
                        visible true
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    configure :mdm_priority do
                        default_value MdmPriority.where( default_priority: true ).first.id
                    end
                    configure :priority_id do
                        default_value MdmPriority.where( default_priority: true ).first.id
                    end
                    configure :mdm_status do
                        default_value MdmStatus.where( status_type: 'Test Blocker', default_status: true ).first.id
                    end
                end
            end

            config.model QaBamTask do
                create do
                    configure :created_by do
                        visible false
                        help ""
                    end
                    field :created_by_id, :hidden do
                        visible true
                        default_value do
                            bindings[:view]._current_user.id
                        end
                    end
                    configure :mdm_priority do
                        default_value MdmPriority.where( default_priority: true ).first.id
                    end
                    configure :mdm_status do
                        default_value MdmStatus.where( status_type: 'QaBam Task', default_status: true ).first.id
                    end
                end
            end
            # END SET USER ID's
            # ***************************

            # Hide columns
            model_list.each do |m|
                config.model m do
                    create do
                        configure :lock_version, :hidden do
                            visible true
                        end
                    end
                    update do
                        configure :lock_version, :hidden do
                            visible true
                        end
                    end
                    list do
                        #exclude_fields :id
                        exclude_fields :lock_version
                    end
                    show do
                        #exclude_fields :id
                        exclude_fields :lock_version
                    end
                end
            end
        end

    end
end
```
