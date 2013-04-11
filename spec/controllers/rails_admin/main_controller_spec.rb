# encoding: utf-8

require 'spec_helper'

describe RailsAdmin::MainController do

  describe "#dashboard" do
    before do
      controller.stub(:render).and_return(true) # no rendering
    end

    it "shows statistics by default" do
      RailsAdmin.config(Player).abstract_model.should_receive(:count).and_return(0)
      controller.dashboard
    end

    it "does not show statistics if turned off" do
      RailsAdmin.config do |c|
        c.actions do
          dashboard do
            statistics false
          end
        end
      end

      RailsAdmin.config(Player).abstract_model.should_not_receive(:count)
      controller.dashboard
    end
  end

  describe "#check_for_cancel" do

    it "redirects to back if params[:bulk_ids] is nil when params[:bulk_action] is present" do
      controller.stub(:back_or_index) { raise StandardError.new('redirected back') }
      expect { get :bulk_delete, { :model_name => "player", :bulk_action =>"bulk_delete" } }.to raise_error('redirected back')
      expect { get :bulk_delete, { :model_name => "player", :bulk_action =>"bulk_delete", :bulk_ids => [] } }.to_not raise_error('redirected back')
    end
  end

  describe "#get_sort_hash" do
    context "options sortable is a hash" do
      before do
        RailsAdmin.config('Player') do
          configure :team do
            sortable do
              :'team.name'
            end
          end
        end
      end

      it "returns the option with no changes" do
        controller.params = { :sort => "team", :model_name =>"players" }
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to eq({:sort=>:"team.name", :sort_reverse=>true})
      end
    end


    it "works with belongs_to associations with label method virtual" do
      controller.params = { :sort => "parent_category", :model_name =>"categories" }
      expect(controller.send(:get_sort_hash, RailsAdmin.config(Category))).to eq({:sort=>"categories.parent_category_id", :sort_reverse=>true})
    end

    context "using mongoid, not supporting joins", :mongoid => true do
      it "gives back the remote table with label name" do
        controller.params = { :sort => "team", :model_name =>"players" }
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to eq({:sort=>"players.team_id", :sort_reverse=>true})
      end
    end

    context "using active_record, supporting joins", :active_record => true do
      it "gives back the local column"  do
        controller.params = { :sort => "team", :model_name =>"players" }
        expect(controller.send(:get_sort_hash, RailsAdmin.config(Player))).to eq({:sort=>"teams.name", :sort_reverse=>true})
      end
    end
  end

  describe "#list_entries called from view" do
    before do
      @teams = 21.times.map { FactoryGirl.create :team }
      controller.params = { :model_name => "teams" }
    end

    it "paginates" do
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, false).to_a.length).to eq(21)
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, true).to_a.length).to eq(20)
    end
  end

  describe "#list_entries called from view with kaminari custom param_name" do
    before do
      @teams = 21.times.map { FactoryGirl.create :team }
      controller.params = { :model_name => "teams" }
      Kaminari.config.param_name = :pagina
    end

    after do
      Kaminari.config.param_name = :page
    end

    it "paginates" do
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, false).to_a.length).to eq(21)
      expect(controller.list_entries(RailsAdmin.config(Team), :index, nil, true).to_a.length).to eq(20)
    end
  end

  describe "#list_entries called with bulk_ids" do
    before do
      @teams = 21.times.map { FactoryGirl.create :team }
      controller.params = { :model_name => "teams", :bulk_action => "bulk_delete", :bulk_ids => @teams.map(&:id) }
    end

    it "does not paginate" do
      expect(controller.list_entries(RailsAdmin.config(Team), :bulk_delete).to_a.length).to eq(21)
    end
  end

  describe "#list_entries for associated_collection" do
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

      expect(controller.list_entries.to_a.length).to eq(@players.size)
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

      expect(controller.list_entries.to_a.length).to eq(3)
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

      expect(controller.list_entries.to_a.length).to eq(@team.revenue.to_i)
    end


    it "limits associated collection records number to 30 if cache_all is false" do
      @players = 40.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all false
        end
      end
      expect(controller.list_entries.to_a.length).to eq(30)
    end

    it "doesn't limit associated collection records number to 30 if cache_all is true" do
      @players = 40.times.map do
        FactoryGirl.create :player
      end

      RailsAdmin.config Team do
        field :players do
          associated_collection_cache_all true
        end
      end
      expect(controller.list_entries.length).to eq(@players.size)
    end

    it "orders associated collection records by desc" do
      @players = 3.times.map do
        FactoryGirl.create :player
      end

      expect(controller.list_entries.to_a.first).to eq(@players.last)
    end
  end

  describe "index" do
    it "uses source association's primary key with :compact, not target model's default primary key", :skip_mongoid => true do
      class TeamWithNumberedPlayers < Team
        has_many :numbered_players, :class_name => 'Player', :primary_key => :number, :foreign_key => 'team_id'
      end
      FactoryGirl.create :team
      TeamWithNumberedPlayers.first.numbered_players = [FactoryGirl.create(:player, :number => 123)]
      get :index, {:model_name => 'player', :source_object_id => Team.first.id, :source_abstract_model => 'team_with_numbered_players', :associated_collection => 'numbered_players', :current_action => :create, :compact => true, :format => :json}
      expect(response.body).to match /\"id\":\"123\"/
    end

    context "as JSON" do
      it "returns strings" do
        FactoryGirl.create :player, :team => (FactoryGirl.create :team)
        get :index, {:model_name => 'player', :source_object_id => Team.first.id, :source_abstract_model => 'team', :associated_collection => 'players', :current_action => :create, :compact => true, :format => :json}
        expect(JSON.parse(response.body).first["id"]).to be_a_kind_of String
      end
    end
  end

  describe "sanitize_params_for!" do
    context "in France" do
      before do
        I18n.locale = :fr
      end
      after do
        I18n.locale = :en
      end

      it "sanitize params recursively in nested forms" do
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

        controller.params = HashWithIndifferentAccess.new({
          "field_test"=>{
            "unallowed_field" => "I shouldn't be here",
            "datetime_field"=>"1 août 2010",
            "nested_field_tests_attributes"=>{
              "new_1330520162002"=>{
                "comment_attributes"=>{
                  "unallowed_field" => "I shouldn't be here",
                  "created_at"=>"2 août 2010"
                },
                "created_at"=>"3 août 2010"
              }
            },
            "comment_attributes"=>{
              "unallowed_field" => "I shouldn't be here",
              "created_at"=>"4 août 2010"
            }
          }
        })

        controller.send(:sanitize_params_for!, :create, RailsAdmin.config(FieldTest), controller.params['field_test'])

        expect(controller.params).to eq({
          "field_test"=>{
            "datetime_field"=>'Sun, 01 Aug 2010 00:00:00 UTC +00:00',
            "nested_field_tests_attributes"=>{
              "new_1330520162002"=>{
                "comment_attributes"=>{
                  "created_at"=>'Mon, 02 Aug 2010 00:00:00 UTC +00:00'
                },
                "created_at"=>'Tue, 03 Aug 2010 00:00:00 UTC +00:00'
              }
            },
            "comment_attributes"=>{
              "created_at"=>'Wed, 04 Aug 2010 00:00:00 UTC +00:00'
            }
          }
        })
      end
    end

    it "allows for delete method with Carrierwave" do

      RailsAdmin.config FieldTest do
        field :carrierwave_asset
        field :dragonfly_asset
        field :paperclip_asset do
          delete_method :delete_paperclip_asset
        end
      end
      controller.params = HashWithIndifferentAccess.new({
        "field_test"=>{
          "carrierwave_asset" => "test",
          "carrierwave_asset_cache" => "test",
          "remove_carrierwave_asset" => "test",
          "dragonfly_asset" => "test",
          "remove_dragonfly_asset" => "test",
          "retained_dragonfly_asset" => "test",
          "paperclip_asset" => "test",
          "delete_paperclip_asset" => "test",
          "should_not_be_here" => "test"
        }
      })

      controller.send(:sanitize_params_for!, :create, RailsAdmin.config(FieldTest), controller.params['field_test'])
      expect(controller.params).to eq(
        "field_test"=>{
          "carrierwave_asset"=>"test",
          "remove_carrierwave_asset"=>"test",
          "carrierwave_asset_cache"=>"test",
          "dragonfly_asset"=>"test",
          "remove_dragonfly_asset"=>"test",
          "retained_dragonfly_asset"=>"test",
          "paperclip_asset"=>"test",
          "delete_paperclip_asset"=>"test"
        })
    end

    it "allows for polymorphic associations parameters" do
      RailsAdmin.config Comment do
        field :commentable
      end

      controller.params = HashWithIndifferentAccess.new({
        "comment"=>{
          "commentable_id" => "test",
          "commentable_type" => "test"
        }
      })
      controller.send(:sanitize_params_for!, :create, RailsAdmin.config(Comment), controller.params['comment'])
      expect(controller.params).to eq(
        "comment"=>{
          "commentable_id" => "test",
          "commentable_type" => "test"
        })
    end
  end


end
