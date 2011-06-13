require 'spec_helper'

describe "RailsAdmin Config DSL" do

  describe "excluded models" do
    excluded_models = [Division, Draft, Fan]

    before(:each) do
      RailsAdmin::Config.excluded_models = excluded_models
    end

    it "should be hidden from navigation" do
      # Make query in team's edit view to make sure loading
      # the related division model config will not mess the navigation
      get rails_admin_new_path(:model_name => "team")
      excluded_models.each do |model|
        response.should have_tag("#nav") do |navigation|
          navigation.should_not have_tag("li a", :content => model.to_s)
        end
      end
    end

    it "should raise NotFound for the list view" do
      get rails_admin_list_path(:model_name => "fan")
      response.status.should equal(404)
    end

    it "should raise NotFound for the create view" do
      get rails_admin_new_path(:model_name => "fan")
      response.status.should equal(404)
    end

    it "should be hidden from other models relations in the edit view" do
      get rails_admin_new_path(:model_name => "team")
      response.should_not have_tag("#team_division_id")
      response.should_not have_tag("input#team_fans")
    end

    it "should raise NoMethodError when an unknown method is called" do
      begin
        RailsAdmin::Config.model Team do
          method_that_doesnt_exist
          fail "calling an unknown method should have failed"
        end
      rescue NoMethodError
        # this is what we want to happen
      end
    end
  end

  describe "model store does not exist" do
    before(:each)  { drop_all_tables }
    after(:all)    { migrate_database }

    it "should not raise an error when the model tables do not exists" do
      config_setup = lambda do
        RailsAdmin.config Team do
          edit do
            field :name
          end
        end
      end

      config_setup.should_not raise_error
    end
  end

  describe "object_label_method" do
    it 'should be configurable' do
      RailsAdmin.config League do
        object_label_method { :custom_name }
      end

      @league = FactoryGirl.create :league

      RailsAdmin.config('League').with(:object => @league).object_label.should == "League '#{@league.name}'"
    end
  end

end
