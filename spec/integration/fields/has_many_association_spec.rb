

require 'spec_helper'

RSpec.describe 'HasManyAssociation field', type: :request do
  subject { page }

  it 'adds a related id to the has_many create team link' do
    @team = FactoryBot.create :team
    visit edit_path(model_name: 'team', id: @team.id)
    is_expected.to have_selector("a[data-link='/admin/player/new?modal=true&player%5Bteam_id%5D=#{@team.id}']")
  end

  context 'when an association is readonly' do
    it 'is not editable' do
      @league = FactoryBot.create :league
      visit edit_path(model_name: 'league', id: @league.id)
      is_expected.not_to have_selector('select#league_team_ids')
      is_expected.to have_selector('select#league_division_ids') # decoy, fails if naming scheme changes
    end
  end

  describe 'has many associations through more than one association' do
    it 'is not editable' do
      @league = FactoryBot.create :league
      visit edit_path(model_name: 'league', id: @league.id)
      expect(page).to have_selector('select#league_division_ids')
      expect(page).to_not have_selector('select#league_player_ids')
    end
  end

  describe 'on create' do
    before do
      @divisions = Array.new(3) { Division.create!(name: "div #{Time.now.to_f}", league: League.create!(name: "league #{Time.now.to_f}")) }
    end

    it 'shows selects' do
      visit new_path(model_name: 'league')
      is_expected.to have_selector('select#league_division_ids')
    end

    it 'creates an object with correct associations' do
      post new_path(model_name: 'league', league: {name: 'National League', division_ids: [@divisions[0].id]})
      @league = RailsAdmin::AbstractModel.new('League').all.to_a.last
      @divisions[0].reload
      expect(@league.divisions).to include(@divisions[0])
      expect(@league.divisions).not_to include(@divisions[1])
      expect(@league.divisions).not_to include(@divisions[2])
    end
  end

  context 'on update' do
    it 'is fillable and emptyable', active_record: true do
      @league = FactoryBot.create :league
      @divisions = Array.new(3) { Division.create!(name: "div #{Time.now.to_f}", league: League.create!(name: "league #{Time.now.to_f}")) }

      put edit_path(model_name: 'league', id: @league.id, league: {name: 'National League', division_ids: [@divisions[0].id]})

      @league.reload
      expect(@league.name).to eq('National League')
      @divisions[0].reload
      expect(@league.divisions).to include(@divisions[0])
      expect(@league.divisions).not_to include(@divisions[1])
      expect(@league.divisions).not_to include(@divisions[2])

      put edit_path(model_name: 'league', id: @league.id, league: {division_ids: ['']})

      @league.reload
      expect(@league.divisions).to be_empty
    end

    context 'with embedded model', mongoid: true do
      it 'is editable' do
        @record = FactoryBot.create :field_test
        2.times.each { |i| @record.embeds.create name: "embed #{i}" }
        visit edit_path(model_name: 'field_test', id: @record.id)
        fill_in 'field_test_embeds_attributes_0_name', with: 'embed 1 edited'
        page.find('#field_test_embeds_attributes_1__destroy', visible: false).set('true')
        click_button 'Save' # first(:button, "Save").click
        @record.reload
        expect(@record.embeds.length).to eq(1)
        expect(@record.embeds[0].name).to eq('embed 1 edited')
      end
    end
  end

  context 'on show' do
    context 'with embedded model', mongoid: true do
      it "does not show link to individual object's page" do
        @record = FactoryBot.create :field_test
        2.times.each { |i| @record.embeds.create name: "embed #{i}" }
        visit show_path(model_name: 'field_test', id: @record.id)
        is_expected.not_to have_link('embed 0')
        is_expected.not_to have_link('embed 1')
      end
    end
  end

  context 'on list' do
    context 'with embedded model', mongoid: true do
      it "does not show link to individual object's page" do
        RailsAdmin.config FieldTest do
          list do
            field :embeds
          end
        end
        @record = FactoryBot.create :field_test
        2.times.each { |i| @record.embeds.create name: "embed #{i}" }
        visit index_path(model_name: 'field_test')
        is_expected.not_to have_link('embed 0')
        is_expected.not_to have_link('embed 1')
      end
    end
  end

  context 'with not nullable foreign key', active_record: true do
    before do
      RailsAdmin.config FieldTest do
        edit do
          field :nested_field_tests do
            nested_form false
          end
        end
      end
      @field_test = FactoryBot.create :field_test
    end

    it 'don\'t allow to remove element', js: true do
      visit edit_path(model_name: 'FieldTest', id: @field_test.id)
      is_expected.not_to have_selector('a.ra-multiselect-item-remove')
      is_expected.not_to have_selector('a.ra-multiselect-item-remove-all')
    end
  end

  context 'with nullable foreign key', active_record: true do
    before do
      RailsAdmin.config Team do
        edit do
          field :players
        end
      end
      @team = FactoryBot.create :team
    end

    it 'allow to remove element', js: true do
      visit edit_path(model_name: 'Team', id: @team.id)
      is_expected.to have_selector('a.ra-multiselect-item-remove')
      is_expected.to have_selector('a.ra-multiselect-item-remove-all')
    end
  end

  context 'with custom primary_key option' do
    let(:user) { FactoryBot.create :managing_user }
    let!(:teams) { [FactoryBot.create(:managed_team, manager: user.email), FactoryBot.create(:managed_team)] }
    before do
      RailsAdmin.config.included_models = [ManagingUser, ManagedTeam]
      RailsAdmin.config ManagingUser do
        field :teams
      end
    end

    it 'allows update' do
      visit edit_path(model_name: 'managing_user', id: user.id)
      expect(find("select#managing_user_team_ids option[value=\"#{teams[0].id}\"]")).to have_content teams[0].name
      select(teams[1].name, from: 'Teams')
      click_button 'Save'
      is_expected.to have_content 'Managing user successfully updated'
      expect(ManagingUser.first.teams).to match_array teams
    end

    context 'when fetching associated objects via xhr' do
      before do
        RailsAdmin.config ManagingUser do
          field(:teams) { associated_collection_cache_all false }
        end
      end

      it 'allows update', js: true do
        visit edit_path(model_name: 'managing_user', id: user.id)
        find('input.ra-multiselect-search').set('T')
        find('.ra-multiselect-collection option', text: teams[1].name).select_option
        find('.ra-multiselect-item-add').click
        click_button 'Save'
        is_expected.to have_content 'Managing user successfully updated'
        expect(ManagingUser.first.teams).to match_array teams
      end
    end
  end

  context 'with composite foreign keys', composite_primary_keys: true do
    let(:fan) { FactoryBot.create(:fan) }
    let!(:fanships) { FactoryBot.create_list(:fanship, 3) }

    describe 'via default field' do
      before do
        RailsAdmin.config Fan do
          field :name
          field :fanships
        end
      end

      it 'shows the current selection' do
        visit edit_path(model_name: 'fan', id: fanships[0].fan.id)
        is_expected.to have_select('Fanships', selected: "Fanship ##{fanships[0].id}")
      end

      it 'allows update' do
        visit edit_path(model_name: 'fan', id: fan.id)
        select("Fanship ##{fanships[0].id}", from: 'Fanships')
        select("Fanship ##{fanships[1].id}", from: 'Fanships')
        click_button 'Save'
        is_expected.to have_content 'Fan successfully updated'
        expect(fan.reload.fanships.map(&:team_id)).to match_array fanships.map(&:team_id)[0..1]
      end
    end

    describe 'via remote-sourced field' do
      before do
        RailsAdmin.config Fan do
          field :name
          field :fanships do
            associated_collection_cache_all false
          end
        end
      end

      it 'allows update', js: true do
        visit edit_path(model_name: 'fan', id: fan.id)
        find('input.ra-multiselect-search').set('F')
        find('.ra-multiselect-collection option', text: "Fanship ##{fanships[0].id}").select_option
        find('.ra-multiselect-collection option', text: "Fanship ##{fanships[1].id}").select_option
        find('.ra-multiselect-item-add').click
        click_button 'Save'
        is_expected.to have_content 'Fan successfully updated'
        expect(fan.reload.fanships.map(&:team_id)).to match_array fanships.map(&:team_id)[0..1]
      end
    end

    describe 'via nested field' do
      let!(:team) { FactoryBot.create :team }
      let!(:fanships) { FactoryBot.create_list(:fanship, 2, fan: fan) }
      before do
        RailsAdmin.config NestedFan do
          field :name
          field :fanships
        end
      end

      it 'allows update' do
        visit edit_path(model_name: 'nested_fan', id: fan.id)
        select(team.name, from: 'nested_fan_fanships_attributes_0_team_id')
        fill_in 'nested_fan_fanships_attributes_1_since', with: '2020-01-23'
        click_button 'Save'
        is_expected.to have_content 'Nested fan successfully updated'
        expect(fan.fanships[0].team).to eq team
        expect(fan.fanships[1].since).to eq Date.new(2020, 1, 23)
      end
    end
  end
end
