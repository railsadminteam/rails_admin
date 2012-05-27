# encoding: utf-8

require 'spec_helper'

describe RailsAdmin::MainController do


  describe "get_sort_hash" do
    it 'should work with belongs_to associations with label method virtual' do
      controller.params = { :sort => "parent_category", :model_name =>"categories" }
      controller.send(:get_sort_hash, RailsAdmin.config(Category)).should == {:sort=>"categories.parent_category_id", :sort_reverse=>true}
    end

    it 'should work with belongs_to associations with label method real column' do
      controller.params = { :sort => "team", :model_name =>"players" }
      controller.send(:get_sort_hash, RailsAdmin.config(Player)).should == {:sort=>"teams.name", :sort_reverse=>true}
    end
  end

  describe "list_entries called from view" do
    before do
      @teams = 40.times.map { FactoryGirl.create :team }
      controller.params = { :model_name => "teams" }
    end

    it "should paginate" do
      controller.list_entries(RailsAdmin.config(Team), :index, nil, false).to_a.length.should == 40
      controller.list_entries(RailsAdmin.config(Team), :index, nil, true).to_a.length.should == 20
    end
  end

  describe "list_entries for associated_collection" do
    before do
      @team = FactoryGirl.create :team
      controller.params = { :associated_collection => "players", :current_action => "update", :source_abstract_model => 'team', :source_object_id => @team.id, :model_name => "player", :action => 'index' }
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

      controller.list_entries.to_a.length.should == @players.size
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

      controller.list_entries.to_a.length.should == 3
    end

    it "scopes associated collection records according to bindings" do
      @team.revenue = BigDecimal.new('3')
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

      controller.list_entries.to_a.length.should == @team.revenue.to_i
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
      controller.list_entries.to_a.length.should == 30

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all true
        end
      end
      controller.list_entries.length.should == @players.size
    end

    it "orders associated collection records by desc" do
      @players = 3.times.map do
        FactoryGirl.create :player
      end

      controller.list_entries.to_a.first.should == @players.last
    end
  end

  describe "index" do
    it "uses source association's primary key with :compact, not target model's default primary key", :skip_mongoid => true do
      class TeamWithNumberedPlayers < Team
        has_many :numbered_players, :class_name => 'Player', :primary_key => :number, :foreign_key => 'team_id'
      end
      FactoryGirl.create :team
      TeamWithNumberedPlayers.first.numbered_players = [FactoryGirl.create(:player, :number => 123)]
      returned = get :index, {:model_name => 'player', :source_object_id => Team.first.id, :source_abstract_model => 'team_with_numbered_players', :associated_collection => 'numbered_players', :current_action => :create, :compact => true, :format => :json}
      returned.body.should =~ /\"id\"\:123/
    end
  end
  
  describe "sanitize_params_for!" do
    it 'sanitize params recursively in nested forms' do
      RailsAdmin.config Comment do
        configure :created_at do
          show
        end
      end
      
      RailsAdmin.config NestedFieldTest do
        configure :created_at do
          show
        end
      end

      I18n.locale = :fr
      controller.params = {
        "field_test"=>{
          :"datetime_field"=>"1 août 2010", 
          "nested_field_tests_attributes"=>{
            "new_1330520162002"=>{
              "comment_attributes"=>{
                :"created_at"=>"2 août 2010"
              },
              :"created_at"=>"3 août 2010"
            }
          }, 
          "comment_attributes"=>{
            :"created_at"=>"4 août 2010"
          }
        }
      }
      
      controller.send(:sanitize_params_for!, :create, RailsAdmin.config(FieldTest), controller.params['field_test'])
      
      controller.params.should == {
        "field_test"=>{
          :datetime_field=>'Sun, 01 Aug 2010 00:00:00 UTC +00:00', 
          "nested_field_tests_attributes"=>{
            "new_1330520162002"=>{
              "comment_attributes"=>{
                :created_at=>'Mon, 02 Aug 2010 00:00:00 UTC +00:00'
              }, 
              :created_at=>'Tue, 03 Aug 2010 00:00:00 UTC +00:00'
            }
          }, 
          "comment_attributes"=>{
            :created_at=>'Wed, 04 Aug 2010 00:00:00 UTC +00:00'
          }
        }
      }
      I18n.locale = :en
    end
  end
end
