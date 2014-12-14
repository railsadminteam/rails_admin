# coding: utf-8

require 'spec_helper'

describe 'RailsAdmin Basic List', type: :request do
  subject { page }

  describe 'GET /admin' do
    it 'responds successfully' do
      visit dashboard_path
    end
  end

  describe 'GET /admin/typo' do
    it "redirects to dashboard and inform the user the model wasn't found" do
      visit '/admin/whatever'
      expect(page.driver.status_code).to eq(404)
      expect(find('.alert-danger')).to have_content("Model 'Whatever' could not be found")
    end
  end

  describe 'GET /admin/balls/545-typo' do
    it "redirects to balls index and inform the user the id wasn't found" do
      visit '/admin/ball/545-typo'
      expect(page.driver.status_code).to eq(404)
      expect(find('.alert-danger')).to have_content("Ball with id '545-typo' could not be found")
    end
  end

  describe 'GET /admin/player as list' do
    it "shows \"List of Models\", should show filters and should show column headers" do
      RailsAdmin.config.default_items_per_page = 1
      2.times { FactoryGirl.create :player } # two pages of players
      visit index_path(model_name: 'player')
      is_expected.to have_content('List of Players')
      is_expected.to have_content('Created at')
      is_expected.to have_content('Updated at')

      # it "shows the show, edit and delete links" do
      is_expected.to have_selector("li[title='Show'] a")
      is_expected.to have_selector("li[title='Edit'] a")
      is_expected.to have_selector("li[title='Delete'] a")

      # it "has the search box with some prompt text" do
      is_expected.to have_selector("input[placeholder='Filter']")

      # https://github.com/sferik/rails_admin/issues/362
      # test that no link uses the "wildcard route" with the main
      # controller and list method
      # it "does not use the 'wildcard route'" do
      is_expected.to have_selector("a[href*='all=true']") # make sure we're fully testing pagination
      is_expected.to have_no_selector("a[href^='/rails_admin/main/list']")
    end
  end

  describe 'GET /admin/player' do
    before do
      @teams = 2.times.collect do
        FactoryGirl.create(:team)
      end
      @players = [
        FactoryGirl.create(:player, retired: true, injured: true, team: @teams[0]),
        FactoryGirl.create(:player, retired: true, injured: false, team: @teams[0]),
        FactoryGirl.create(:player, retired: false, injured: true, team: @teams[1]),
        FactoryGirl.create(:player, retired: false, injured: false, team: @teams[1]),
      ]
    end

    it 'allows to query on any attribute' do
      RailsAdmin.config Player do
        list do
          field :name
          field :team
          field :injured
          field :retired
        end
      end

      visit index_path(model_name: 'player', query: @players[0].name)
      is_expected.to have_content(@players[0].name)
      (1..3).each do |i|
        is_expected.to have_no_content(@players[i].name)
      end
    end

    it 'allows to filter on one attribute' do
      RailsAdmin.config Player do
        list do
          field :name
          field :team
          field :injured
          field :retired
        end
      end

      visit index_path(model_name: 'player', f: {injured: {'1' => {v: 'true'}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_no_content(@players[1].name)
      is_expected.to have_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to combine filters on two different attributes' do
      RailsAdmin.config Player do
        list do
          field :name
          field :team
          field :injured
          field :retired
        end
      end

      visit index_path(model_name: 'player', f: {retired: {'1' => {v: 'true'}}, injured: {'1' => {v: 'true'}}})
      is_expected.to have_content(@players[0].name)
      (1..3).each do |i|
        is_expected.to have_no_content(@players[i].name)
      end
    end

    it 'allows to filter on belongs_to relationships' do
      RailsAdmin.config Player do
        list do
          field :name
          field :team
          field :injured
          field :retired
        end
      end

      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams[0].name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to disable search on attributes' do
      RailsAdmin.config Player do
        list do
          field :position
          field :name do
            searchable false
          end
        end
      end
      visit index_path(model_name: 'player', query: @players[0].name)
      is_expected.to have_no_content(@players[0].name)
    end

    it 'allows to search a belongs_to attribute over the base table' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable Player => :team_id
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.id}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search a belongs_to attribute over the target table' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable Team => :name
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search a belongs_to attribute over the target table with a table name specified as a hash' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable teams: :name
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search a belongs_to attribute over the target table with a table name specified as a string' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable 'teams.name'
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search a belongs_to attribute over the label method by default' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search a belongs_to attribute over the target table when an attribute is specified' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable :name
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'allows to search over more than one attribute' do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable [:name, {Player => :team_id}]
          end
        end
      end
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}, '2' => {v: @teams.first.id, o: 'is'}}})
      is_expected.to have_content(@players[0].name)
      is_expected.to have_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
      # same with a different id
      visit index_path(model_name: 'player', f: {team: {'1' => {v: @teams.first.name}, '2' => {v: @teams.last.id, o: 'is'}}})
      is_expected.to have_no_content(@players[0].name)
      is_expected.to have_no_content(@players[1].name)
      is_expected.to have_no_content(@players[2].name)
      is_expected.to have_no_content(@players[3].name)
    end

    it 'displays base filters when no filters are present in the params' do
      RailsAdmin.config Player do
        list do
          filters [:name, :team]
        end
      end

      get index_path(model_name: 'player')
      expect(response.body).to include(%{$.filters.append("Name", "name", "string", "", null, "", 1);}) # rubocop:disable StringLiterals
      expect(response.body).to include(%{$.filters.append("Team", "team", "belongs_to_association", "", null, "", 2);}) # rubocop:diasble StringLiterals
    end
  end

  describe 'GET /admin/player with 2 objects' do
    before do
      @players = 2.times.collect { FactoryGirl.create :player }
      visit index_path(model_name: 'player')
    end

    it "shows \"2 results\"" do
      is_expected.to have_content('2 players')
    end
  end

  describe 'GET /admin/player with 2 objects' do
    before do
      @players = 2.times.collect { FactoryGirl.create :player }
      visit index_path(model_name: 'player')
    end

    it "shows \"2 results\"" do
      is_expected.to have_content('2 players')
    end
  end

  describe 'GET /admin/player with 3 pages, page 2' do
    before do
      RailsAdmin.config.default_items_per_page = 1
      items_per_page = RailsAdmin.config.default_items_per_page
      (items_per_page * 3).times { FactoryGirl.create(:player) }
      visit index_path(model_name: 'player', page: 2)
    end

    it 'paginates correctly' do
      expect(find('ul.pagination li:first')).to have_content('« Prev')
      expect(find('ul.pagination li:last')).to have_content('Next »')
      expect(find('ul.pagination li.active')).to have_content('2')
    end
  end

  describe 'list with 3 pages, page 3' do
    before do
      items_per_page = RailsAdmin.config.default_items_per_page
      @players = (items_per_page * 3).times.collect { FactoryGirl.create(:player) }
      visit index_path(model_name: 'player', page: 3)
    end

    it 'paginates correctly and contain the right item' do
      expect(find('ul.pagination li:first')).to have_content('« Prev')
      expect(find('ul.pagination li:last')).to have_content('Next »')
      expect(find('ul.pagination li.active')).to have_content('3')
    end
  end

  describe 'GET /admin/player show all' do
    it 'responds successfully with a single model' do
      FactoryGirl.create :player
      visit index_path(model_name: 'player', all: true)
      expect(find('div.total-count')).to have_content('1 player')
      expect(find('div.total-count')).not_to have_content('1 players')
    end

    it 'responds successfully with multiple models' do
      2.times.collect { FactoryGirl.create :player }
      visit index_path(model_name: 'player', all: true)
      expect(find('div.total-count')).to have_content('2 players')
    end
  end

  describe 'GET /admin/player show with pagination disabled by :associated_collection' do
    it 'responds successfully' do
      @team = FactoryGirl.create :team
      2.times.collect { FactoryGirl.create :player, team: @team }
      visit index_path(model_name: 'player', associated_collection: 'players', compact: true, current_action: 'update', source_abstract_model: 'team', source_object_id: @team.id)
      expect(find('div.total-count')).to have_content('2 players')
    end
  end

  describe 'list as compact json' do
    it 'has_content an array with 2 elements and contain an array of elements with keys id and label' do
      2.times.collect { FactoryGirl.create :player }
      get index_path(model_name: 'player', compact: true, format: :json)
      expect(ActiveSupport::JSON.decode(response.body).length).to eq(2)
      ActiveSupport::JSON.decode(response.body).each do |object|
        expect(object).to have_key('id')
        expect(object).to have_key('label')
      end
    end
  end

  describe 'search operator' do
    let(:player) { FactoryGirl.create :player }

    before do
      expect(Player.count).to eq(0)
    end

    it 'finds the player if the query matches the default search opeartor' do
      RailsAdmin.config do |config|
        config.default_search_operator = 'ends_with'
        config.model Player do
          list { field :name }
        end
      end
      visit index_path(model_name: 'player', query: player.name[2, -1])
      is_expected.to have_content(player.name)
    end

    it 'does not find the player if the query does not match the default search opeartor' do
      RailsAdmin.config do |config|
        config.default_search_operator = 'ends_with'
        config.model Player do
          list { field :name }
        end
      end
      visit index_path(model_name: 'player', query: player.name[0, 2])
      is_expected.to have_no_content(player.name)
    end

    it 'finds the player if the query matches the specified search operator' do
      RailsAdmin.config Player do
        list do
          field :name do
            search_operator 'starts_with'
          end
        end
      end
      visit index_path(model_name: 'player', query: player.name[0, 2])
      is_expected.to have_content(player.name)
    end

    it 'does not find the player if the query does not match the specified search operator' do
      RailsAdmin.config Player do
        list do
          field :name do
            search_operator 'starts_with'
          end
        end
      end
      visit index_path(model_name: 'player', query: player.name[1..-1])
      is_expected.to have_no_content(player.name)
    end
  end

  describe 'list for objects with overridden to_param' do
    before do
      @ball = FactoryGirl.create :ball

      visit index_path(model_name: 'ball')
    end

    it 'shows the show, edit and delete links with valid url' do
      is_expected.to have_selector("td a[href='/admin/ball/#{@ball.id}']")
      is_expected.to have_selector("td a[href='/admin/ball/#{@ball.id}/edit']")
      is_expected.to have_selector("td a[href='/admin/ball/#{@ball.id}/delete']")
    end
  end

  describe 'Scopes' do
    before do
      RailsAdmin.config do |config|
        config.model Team do
          list do
            scopes [nil, :red, :white]
          end
        end
      end
      @teams = [
        FactoryGirl.create(:team, color: 'red'),
        FactoryGirl.create(:team, color: 'red'),
        FactoryGirl.create(:team, color: 'white'),
        FactoryGirl.create(:team, color: 'black'),
      ]
    end

    it 'displays configured scopes' do
      visit index_path(model_name: 'team')
      expect(find('#scope_selector li:first')).to have_content('All')
      expect(find('#scope_selector li:nth-child(2)')).to have_content('Red')
      expect(find('#scope_selector li:nth-child(3)')).to have_content('White')
      expect(find('#scope_selector li:last')).to have_content('White')
      expect(find('#scope_selector li.active')).to have_content('All')
    end

    it 'shows only scoped records' do
      visit index_path(model_name: 'team')
      is_expected.to have_content(@teams[0].name)
      is_expected.to have_content(@teams[1].name)
      is_expected.to have_content(@teams[2].name)
      is_expected.to have_content(@teams[3].name)

      visit index_path(model_name: 'team', scope: 'red')
      expect(find('#scope_selector li.active')).to have_content('Red')
      is_expected.to have_content(@teams[0].name)
      is_expected.to have_content(@teams[1].name)
      is_expected.to have_no_content(@teams[2].name)
      is_expected.to have_no_content(@teams[3].name)

      visit index_path(model_name: 'team', scope: 'white')
      expect(find('#scope_selector li.active')).to have_content('White')
      is_expected.to have_no_content(@teams[0].name)
      is_expected.to have_no_content(@teams[1].name)
      is_expected.to have_content(@teams[2].name)
      is_expected.to have_no_content(@teams[3].name)
    end
    it 'shows all records instead when scope not in list' do
      visit index_path(model_name: 'team', scope: 'green')
      is_expected.to have_content(@teams[0].name)
      is_expected.to have_content(@teams[1].name)
      is_expected.to have_content(@teams[2].name)
      is_expected.to have_content(@teams[3].name)
    end
    describe 'i18n' do
      before :each do
        en = {admin: {scopes: {
          _all: 'every',
          red: 'krasnyj',
        }}}
        I18n.backend.store_translations(:en, en)
      end
      after { I18n.reload! }
      context 'global' do
        it 'displays configured scopes' do
          visit index_path(model_name: 'team')
          expect(find('#scope_selector li:first')).to have_content('every')
          expect(find('#scope_selector li:nth-child(2)')).to have_content('krasnyj')
          expect(find('#scope_selector li:nth-child(3)')).to have_content('White')
          expect(find('#scope_selector li:last')).to have_content('White')
          expect(find('#scope_selector li.active')).to have_content('every')
        end
      end
      context 'per model' do
        before :each do
          en = {admin: {scopes: {team: {
            _all: 'any',
            red: 'kr',
          }}}}
          I18n.backend.store_translations(:en, en)
        end
        after { I18n.reload! }
        it 'displays configured scopes' do
          visit index_path(model_name: 'team')
          expect(find('#scope_selector li:first')).to have_content('any')
          expect(find('#scope_selector li:nth-child(2)')).to have_content('kr')
          expect(find('#scope_selector li:nth-child(3)')).to have_content('White')
          expect(find('#scope_selector li:last')).to have_content('White')
          expect(find('#scope_selector li.active')).to have_content('any')
        end
      end
    end
  end
end
