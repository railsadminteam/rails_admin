require 'spec_helper'

describe RailsAdmin::MainController do
  describe "list_entries called from view" do
    before do
      @teams = 40.times.map { FactoryGirl.create :team }
      controller.params = { :model_name => "teams" }
    end

    it "should paginate" do
      controller.list_entries(RailsAdmin.config(Team), :index, nil, false).length.should == 40
      controller.list_entries(RailsAdmin.config(Team), :index, nil, true).length.should == 20
    end
  end

  describe "list_entries for associated_collection" do
    before do
      @team = FactoryGirl.create :team
      controller.params = { :associated_collection => "players", :current_action => "update", :source_abstract_model => 'teams', :source_object_id => @team.id, :model_name => "players", :action => 'index' }
      controller.get_model # set @model_config for Team
    end

    it "doesn't scope associated collection records when associated_collection_scope is nil" do
      @players = 2.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope false
        end
      end

      controller.list_entries.length.should == @players.size
    end

    it "scopes associated collection records according to associated_collection_scope" do
      @players = 4.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            Proc.new { |scope| scope.limit(3) }
          end
        end
      end

      controller.list_entries.length.should == 3
    end

    it "scopes associated collection records according to bindings" do
      @team.revenue = 3
      @team.save

      @players = 5.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            team = bindings[:object]
            Proc.new { |scope|
              scope.limit(team.revenue)
            }
          end
        end
      end

      controller.list_entries.length.should == @team.revenue
    end


    it "limits associated collection records number to 30 if cache_all is false and doesn't otherwise" do
      @players = 40.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all false
        end
      end
      controller.list_entries.length.should == 30

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all true
        end
      end
      controller.list_entries.length.should == @players.size

    end

  end
end
