require 'spec_helper'

describe "RailsAdmin Config DSL" do

  subject { page }

  describe "excluded models" do
    excluded_models = [Division, Draft, Fan]

    before(:each) do
      RailsAdmin::Config.excluded_models = excluded_models
    end

    it "should be hidden from navigation" do
      # Make query in team's edit view to make sure loading
      # the related division model config will not mess the navigation
      visit new_path(:model_name => "team")
      within("#nav") do
        excluded_models.each do |model|
          should have_no_selector("li a", :text => model.to_s)
        end
      end
    end

    it "should raise NotFound for the list view" do
      visit list_path(:model_name => "fan")
      page.driver.status_code.should eql(404)
    end

    it "should raise NotFound for the create view" do
      visit new_path(:model_name => "fan")
      page.driver.status_code.should eql(404)
    end

    it "should be hidden from other models relations in the edit view" do
      visit new_path(:model_name => "team")
      should_not have_selector("#team_division")
      should_not have_selector("input#team_fans")
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

  describe "compact_show_view" do

    it 'should hide empty fields in show view by default' do
      @player = FactoryGirl.create :player
      visit show_path(:model_name => "league", :id => @player.id)
      should_not have_css("div.player_born_on")
    end


    it 'should be disactivable' do
      RailsAdmin.config do |c|
        c.compact_show_view = false
      end

      @player = FactoryGirl.create :player
      visit show_path(:model_name => "player", :id => @player.id)
      should have_css("div.player_born_on")
    end
  end

  describe "search operator" do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('player') }
    let(:model_config) { RailsAdmin.config(abstract_model) }
    let(:queryable_fields) { model_config.list.fields.select(&:queryable?) }

    context "when no search operator is specified for the field" do
      it "uses 'default' search operator" do
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == RailsAdmin::Config.default_search_operator
      end

      it "uses config.default_search_operator if set" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == RailsAdmin::Config.default_search_operator
      end
    end

    context "when search operator is specified for the field" do
      it "uses specified search operator" do
        RailsAdmin.config Player do
          list do
            fields do
              search_operator "starts_with"
            end
          end
        end
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == "starts_with"
      end

      it "uses specified search operator even if config.default_search_operator set" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'

          config.model Player do
            list do
              fields do
                search_operator "ends_with"
              end
            end
          end
        end
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == "ends_with"
      end
    end
  end


end
