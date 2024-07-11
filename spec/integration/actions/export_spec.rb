

require 'spec_helper'
require 'csv'

RSpec.describe 'Export action', type: :request do
  subject { page }

  let!(:player) { FactoryBot.create(:player) }

  it 'exports to CSV' do
    visit export_path(model_name: 'player')
    click_button 'Export to csv'
    is_expected.to have_content player.name
  end

  it 'exports to JSON' do
    visit export_path(model_name: 'player')
    click_button 'Export to json'
    is_expected.to have_content player.name
  end

  it 'exports to XML' do
    pending "Mongoid does not support to_xml's :include option" if CI_ORM == :mongoid
    visit export_path(model_name: 'player')
    click_button 'Export to xml'

    is_expected.to have_content player.name
  end

  it 'works with Turbo Drive enabled', js: true do
    visit export_path(model_name: 'player')
    page.execute_script 'console.error = function(error) { throw error }'
    expect { find_button('Export to csv').trigger('click') }.not_to raise_error
  end

  it 'does not break when nothing is checked' do
    visit export_path(model_name: 'comment')
    all('input[type="checkbox"]').each(&:uncheck)
    expect { click_button 'Export to csv' }.not_to raise_error
  end

  describe 'with associations' do
    let!(:players) { FactoryBot.create_list(:player, 3) }
    let(:team) { FactoryBot.create :team }
    let(:draft) { FactoryBot.create :draft }
    let(:comments) { FactoryBot.create_list(:comment, 2) }

    before do
      player.team = team
      player.draft = draft
      player.comments = comments
      player.save
    end

    it 'exports to CSV with default schema, containing properly translated header and follow configuration' do
      RailsAdmin.config do |c|
        c.model Player do
          include_all_fields
          field :name do
            export_value do
              "#{value} exported"
            end
          end

          field :json_field, :json do
            formatted_value do
              '{}'
            end
          end
        end
      end

      visit export_path(model_name: 'player')
      is_expected.to have_content 'Select fields to export'
      select "<comma> ','", from: 'csv_options_generator_col_sep'
      click_button 'Export to csv'
      csv = CSV.parse page.driver.response.body.force_encoding('utf-8') # comes through as us-ascii on some platforms
      expect(csv[0]).to match_array ['Id', 'Created at', 'Updated at', 'Deleted at', 'Name', 'Position',
                                     'Number', 'Retired', 'Injured', 'Born on', 'Notes', 'Suspended', 'Formation', 'Json field', 'Id [Team]', 'Created at [Team]',
                                     'Updated at [Team]', 'Name [Team]', 'Logo url [Team]', 'Team Manager [Team]', 'Ballpark [Team]',
                                     'Mascot [Team]', 'Founded [Team]', 'Wins [Team]', 'Losses [Team]', 'Win percentage [Team]',
                                     'Revenue [Team]', 'Color [Team]', 'Custom field [Team]', 'Main Sponsor [Team]', 'Id [Draft]', 'Created at [Draft]',
                                     'Updated at [Draft]', 'Date [Draft]', 'Round [Draft]', 'Pick [Draft]', 'Overall [Draft]',
                                     'College [Draft]', 'Notes [Draft]', 'Id [Comments]', 'Content [Comments]', 'Created at [Comments]',
                                     'Updated at [Comments]']
      expect(csv.flatten).to include("#{player.name} exported")
      expect(csv.flatten).to include(player.team.name)
      expect(csv.flatten).to include(player.draft.college)

      expect(csv.flatten.join(' ')).to include(player.comments.first.content.split("\n").first.strip)
      expect(csv.flatten.join(' ')).to include(player.comments.second.content.split("\n").first.strip)
    end

    let(:custom_schema) do
      # removed schema=>only=>created_at
      {
        'only' => [PK_COLUMN.to_s, 'updated_at', 'deleted_at', 'name', 'position', 'number', 'retired', 'injured', 'born_on', 'notes', 'suspended'],
        'include' => {
          'team' => {'only' => [PK_COLUMN.to_s, 'created_at', 'updated_at', 'name', 'logo_url', 'manager', 'ballpark', 'mascot', 'founded', 'wins', 'losses', 'win_percentage', 'revenue', 'color']},
          'draft' => {'only' => [PK_COLUMN.to_s, 'created_at', 'updated_at', 'date', 'round', 'pick', 'overall', 'college', 'notes']},
          'comments' => {'only' => [PK_COLUMN.to_s, 'content', 'created_at', 'updated_at']},
        },
      }
    end

    it 'exports to CSV with custom schema' do
      page.driver.post(export_path(model_name: 'player', schema: custom_schema, csv: true, all: true, csv_options: {generator: {col_sep: ','}}))
      csv = CSV.parse page.driver.response.body
      expect(csv[0]).not_to include('Created at')
    end

    it 'exports polymorphic fields the easy way for now' do
      visit export_path(model_name: 'comment')
      select "<comma> ','", from: 'csv_options_generator_col_sep'
      click_button 'Export to csv'
      csv = CSV.parse page.driver.response.body
      expect(csv[0]).to match_array ['Id', 'Commentable', 'Commentable type', 'Content', 'Created at', 'Updated at']
      csv[1..].each do |line|
        expect(line[csv[0].index('Commentable')]).to eq(player.id.to_s)
        expect(line[csv[0].index('Commentable type')]).to eq(player.class.to_s)
      end
    end
  end

  context 'on cancel' do
    before do
      @player = FactoryBot.create :player
      visit export_path(model_name: 'player')
    end

    it 'does nothing', js: true do
      find_button('Cancel').trigger('click')
      is_expected.to have_text 'No actions were taken'
    end
  end

  describe 'bulk export' do
    it 'is supported' do
      visit index_path(model_name: 'player')
      click_link 'Export found Players'
      is_expected.to have_content('Select fields to export')
    end

    describe 'with model scope' do
      let!(:comments) { %w[something anything].map { |content| FactoryBot.create :comment_confirmed, content: content } }
      before do
        RailsAdmin.config do |config|
          config.model Comment::Confirmed do
            scope { Comment::Confirmed.unscoped }
          end
        end
      end

      it 'overrides default_scope' do
        page.driver.post(export_path(model_name: 'comment~confirmed', schema: {only: ['content']}, csv: true, all: true, csv_options: {generator: {col_sep: ','}}, bulk_ids: comments.map(&:id)))
        csv = CSV.parse page.driver.response.body
        expect(csv.flatten).to match_array %w[Content something anything]
      end
    end
  end

  context 'with composite_primary_keys', composite_primary_keys: true do
    let!(:fanship) { FactoryBot.create(:fanship) }

    it 'exports to CSV' do
      visit export_path(model_name: 'fanship')
      click_button 'Export to csv'
      is_expected.to have_content fanship.fan.name
      is_expected.to have_content fanship.team.name
    end
  end
end
