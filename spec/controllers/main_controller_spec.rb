require 'spec_helper'

describe RailsAdmin::MainController do
  describe "list_entries for associated_collection" do
    before :each do
      @team = FactoryGirl.create :team
      @players = 10.times.each do
        FactoryGirl.create :player
      end
      controller.params = { :associated_collection => "players", :compact => true, :current_action => "update", :object_id => @team.id, :model_name => "teams" }
      controller.get_model # set @model_config for Team
    end
    
    it "doesn't scope associated collection records when associated_collection_scope is nil" do
      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            nil
          end
        end
      end

      controller.list_entries.length.should == 10
    end
    
    it "scopes associated collection records according to associated_collection_scope" do
      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            Proc.new { |scope|
              scope.limit(3)
            }
          end
        end
      end
      
      controller.list_entries.length.should == 3
    end
    
    it "scopes associated collection records according to bindings" do
      RailsAdmin.config Team do
        field :players do
          associated_collection_scope do
            team = bindings[:object]
            Proc.new { |scope|
              scope.limit(team.id)
            }
          end
        end
      end

      controller.list_entries.length.should == @team.id
    end

  end
end
