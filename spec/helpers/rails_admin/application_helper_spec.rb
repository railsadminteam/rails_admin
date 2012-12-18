require 'spec_helper'
require 'cancan'

class TestAbility
  include CanCan::Ability
  def initialize(user)
    can :access, :rails_admin
    can :edit, FieldTest
    cannot :edit, FieldTest, string_field: 'dangerous'
  end
end

describe RailsAdmin::ApplicationHelper do
  describe '#authorized?' do
    before do
      RailsAdmin.config.stub(_current_user: FactoryGirl.create(:user))
      helper.instance_variable_set('@authorization_adapter', RailsAdmin::AUTHORIZATION_ADAPTERS[:cancan].new(RailsAdmin.config, TestAbility))
    end

    it 'doesn\'t test unpersisted objects' do
      am = RailsAdmin.config(FieldTest).abstract_model
      expect(helper.authorized?(:edit, am, FactoryGirl.create(:field_test, string_field: 'dangerous'))).to be_false
      expect(helper.authorized?(:edit, am, FactoryGirl.create(:field_test, string_field: 'not-dangerous'))).to be_true
      expect(helper.authorized?(:edit, am, FactoryGirl.build(:field_test, string_field: 'dangerous'))).to be_true
    end
  end

  describe 'with #authorized? stubbed' do
    before do
      controller.stub(:authorized?).and_return(true)
    end

    describe "#current_action?" do
      it "returns true if current_action, false otherwise" do
        @action = RailsAdmin::Config::Actions.find(:index)

        expect(helper.current_action?(RailsAdmin::Config::Actions.find(:index))).to be_true
        expect(helper.current_action?(RailsAdmin::Config::Actions.find(:show))).not_to be_true
      end
    end

    describe "#action" do
      it "returns action by :custom_key" do
        RailsAdmin.config do |config|
          config.actions do
            dashboard do
              custom_key :my_custom_dashboard_key
            end
          end
        end
        expect(helper.action(:my_custom_dashboard_key)).to be
      end

      it "returns only visible actions" do
        RailsAdmin.config do |config|
          config.actions do
            dashboard do
              visible false
            end
          end
        end

        expect(helper.action(:dashboard)).to be_nil
      end

      it "returns only visible actions, passing all bindings" do
        RailsAdmin.config do |config|
          config.actions do
            member :test_bindings do
              visible do
                bindings[:controller].is_a?(ActionView::TestCase::TestController) and
                bindings[:abstract_model].model == Team and
                bindings[:object].is_a? Team
              end
            end
          end
        end
        expect(helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Team), Team.new)).to be
        expect(helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Team), Player.new)).to be_nil
        expect(helper.action(:test_bindings, RailsAdmin::AbstractModel.new(Player), Team.new)).to be_nil
      end
    end

    describe "#actions" do
      it "returns actions by type" do
        abstract_model = RailsAdmin::AbstractModel.new(Player)
        object = FactoryGirl.create :player
        expect(helper.actions(:all, abstract_model, object).map(&:custom_key)).to eq([:dashboard, :index, :show, :new, :edit, :export, :delete, :bulk_delete, :history_show, :history_index, :show_in_app])
        expect(helper.actions(:root, abstract_model, object).map(&:custom_key)).to eq([:dashboard])
        expect(helper.actions(:collection, abstract_model, object).map(&:custom_key)).to eq([:index, :new, :export, :bulk_delete, :history_index])
        expect(helper.actions(:member, abstract_model, object).map(&:custom_key)).to eq([:show, :edit, :delete, :history_show, :show_in_app])
      end

      it "only returns visible actions, passing bindings correctly" do
        RailsAdmin.config do |config|
          config.actions do
            member :test_bindings do
              visible do
                bindings[:controller].is_a?(ActionView::TestCase::TestController) and
                bindings[:abstract_model].model == Team and
                bindings[:object].is_a? Team
              end
            end
          end
        end

        expect(helper.actions(:all, RailsAdmin::AbstractModel.new(Team), Team.new).map(&:custom_key)).to eq([:test_bindings])
        expect(helper.actions(:all, RailsAdmin::AbstractModel.new(Team), Player.new).map(&:custom_key)).to eq([])
        expect(helper.actions(:all, RailsAdmin::AbstractModel.new(Player), Team.new).map(&:custom_key)).to eq([])
      end
    end

    describe "#wording_for" do
      it "gives correct wording even if action is not visible" do
        RailsAdmin.config do |config|
          config.actions do
            index do
              visible false
            end
          end
        end

        expect(helper.wording_for(:menu, :index)).to eq("List")
      end

      it "passes correct bindings" do
        expect(helper.wording_for(:title, :edit, RailsAdmin::AbstractModel.new(Team), Team.new(:name => 'the avengers'))).to eq("Edit Team 'the avengers'")
      end

      it "defaults correct bindings" do
        @action = RailsAdmin::Config::Actions.find :edit
        @abstract_model = RailsAdmin::AbstractModel.new(Team)
        @object = Team.new(:name => 'the avengers')
        expect(helper.wording_for(:title)).to eq("Edit Team 'the avengers'")
      end

      it "does not try to use the wrong :label_metod" do
        @abstract_model = RailsAdmin::AbstractModel.new(Draft)
        @object = Draft.new

        expect(helper.wording_for(:link, :new, RailsAdmin::AbstractModel.new(Team))).to eq("Add a new Team")
      end

    end

    describe "#breadcrumb" do
      it "gives us a breadcrumb" do
        @action = RailsAdmin::Config::Actions.find(:edit, {:abstract_model => RailsAdmin::AbstractModel.new(Team), :object => Team.new(:name => 'the avengers')})
        bc = helper.breadcrumb
        expect(bc).to match /Dashboard/ # dashboard
        expect(bc).to match /Teams/ # list
        expect(bc).to match /the avengers/  # show
        expect(bc).to match /Edit/ # current (edit)
      end
    end

    describe "#menu_for" do
      it "passes model and object as bindings and generates a menu, excluding non-get actions" do
        RailsAdmin.config do |config|
          config.actions do
            dashboard
            index do
              visible do
                bindings[:abstract_model].model == Team
              end
            end
            show do
              visible do
                bindings[:object].class == Team
              end
            end
            delete do
              http_methods [:post, :put, :delete]
            end
          end
        end

        @action = RailsAdmin::Config::Actions.find :show
        @abstract_model = RailsAdmin::AbstractModel.new(Team)
        @object = Team.new(:name => 'the avengers')

        expect(helper.menu_for(:root)).to match /Dashboard/
        expect(helper.menu_for(:collection, @abstract_model)).to match /List/
        expect(helper.menu_for(:member, @abstract_model, @object)).to match /Show/

        @abstract_model = RailsAdmin::AbstractModel.new(Player)
        @object = Player.new
        expect(helper.menu_for(:collection, @abstract_model)).not_to match /List/
        expect(helper.menu_for(:member, @abstract_model, @object)).not_to match /Show/
      end

      it "excludes non-get actions" do
        RailsAdmin.config do |config|
          config.actions do
            dashboard do
              http_methods [:post, :put, :delete]
            end
          end
        end

        @action = RailsAdmin::Config::Actions.find :dashboard
        expect(helper.menu_for(:root)).not_to match /Dashboard/
      end
    end

    describe "#main_navigation" do
      it "shows included models" do
        RailsAdmin.config do |config|
          config.included_models = [Ball, Comment]
        end
        expect(helper.main_navigation).to match /(nav\-header).*(Navigation).*(Balls).*(Comments)/m
      end

      it "does not draw empty navigation labels" do
        RailsAdmin.config do |config|
          config.included_models = [Ball, Comment, Comment::Confirmed]
          config.model Comment do
            navigation_label 'Commentz'
          end
          config.model Comment::Confirmed do
            label_plural 'Confirmed'
          end
        end
        expect(helper.main_navigation).to match /(nav\-header).*(Navigation).*(Balls).*(Commentz).*(Confirmed)/m
        expect(helper.main_navigation).not_to match /(nav\-header).*(Navigation).*(Balls).*(Commentz).*(Confirmed).*(Comment)/m
      end

      it "does not show unvisible models" do
        RailsAdmin.config do |config|
          config.included_models = [Ball, Comment]
          config.model Comment do
            hide
          end
        end
        result = helper.main_navigation
        expect(result).to match /(nav\-header).*(Navigation).*(Balls)/m
        expect(result).not_to match "Comments"
      end

      it "shows children of hidden models" do # https://github.com/sferik/rails_admin/issues/978
        RailsAdmin.config do |config|
          config.included_models = [Ball, Hardball]
          config.model Ball do
            hide
          end
        end
        expect(helper.main_navigation).to match /(nav\-header).*(Navigation).*(Hardballs)/m
      end

      it "shows children of excluded models" do
        RailsAdmin.config do |config|
          config.included_models = [Hardball]
        end
        expect(helper.main_navigation).to match /(nav\-header).*(Navigation).*(Hardballs)/m
      end

      it "nests in navigation label" do
        RailsAdmin.config do |config|
          config.included_models = [Comment]
          config.model Comment do
            navigation_label 'commentable'
          end
        end
        expect(helper.main_navigation).to match /(nav\-header).*(commentable).*(Comments)/m
      end

      it "nests in parent model" do
        RailsAdmin.config do |config|
          config.included_models = [Player, Comment]
          config.model Comment do
            parent Player
          end
        end
        expect(helper.main_navigation).to match /(Players).* (nav\-level\-1).*(Comments)/m
      end

      it "orders" do
        RailsAdmin.config do |config|
          config.included_models = [Player, Comment]
        end
        expect(helper.main_navigation).to match /(Comments).*(Players)/m

        RailsAdmin.config(Comment) do
          weight 1
        end
        expect(helper.main_navigation).to match /(Players).*(Comments)/m
      end
    end

    describe "#static_navigation" do
      it "shows not show static nav if no static links defined" do
        RailsAdmin.config do |config|
          config.navigation_static_links = {}
        end
        expect(helper.static_navigation).to be_empty
      end

      it "shows links if defined" do
        RailsAdmin.config do |config|
          config.navigation_static_links = {
            'Test Link' => 'http://www.google.com'
          }
        end
        expect(helper.static_navigation).to match /Test Link/
      end

      it "shows default header if navigation_static_label not defined in config" do
        RailsAdmin.config do |config|
          config.navigation_static_links = {
            'Test Link' => 'http://www.google.com'
          }
        end
        expect(helper.static_navigation).to match I18n.t('admin.misc.navigation_static_label')
      end

      it "shows custom header if defined" do
        RailsAdmin.config do |config|
          config.navigation_static_label = "Test Header"
          config.navigation_static_links = {
            'Test Link' => 'http://www.google.com'
          }
        end
        expect(helper.static_navigation).to match /Test Header/
      end
    end

    describe "#bulk_menu" do
      it "includes all visible bulkable actions" do
        RailsAdmin.config do |config|
          config.actions do
            index
            collection :zorg do
              bulkable true
              action_name :zorg_action
            end
            collection :blub do
              bulkable true
              visible do
                bindings[:abstract_model].model == Team
              end
            end
          end
        end
        @action = RailsAdmin::Config::Actions.find :index
        result = helper.bulk_menu(RailsAdmin::AbstractModel.new(Team))
        expect(result).to match "zorg_action"
        expect(result).to match "blub"

        expect(helper.bulk_menu(RailsAdmin::AbstractModel.new(Player))).not_to match "blub"
      end
    end
  end
end
