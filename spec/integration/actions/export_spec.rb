require 'spec_helper'
require 'csv'

RSpec.describe 'Export action', type: :request do
  subject { page }

  before do
    Comment.all.collect(&:destroy) # rspec bug => doesn't get destroyed with transaction

    @players = FactoryBot.create_list(:player, 4)
    @player = @players.first
    @player.team = FactoryBot.create :team
    @player.draft = FactoryBot.create :draft
    @player.comments = (@comments = Array.new(2) { FactoryBot.create(:comment) })
    @player.save

    @abstract_model = RailsAdmin::AbstractModel.new(Player)

    # removed schema=>only=>created_at
    @non_default_schema = {
      'only' => [PK_COLUMN.to_s, 'updated_at', 'deleted_at', 'name', 'position', 'number', 'retired', 'injured', 'born_on', 'notes', 'suspended'],
      'include' => {
        'team' => {'only' => [PK_COLUMN.to_s, 'created_at', 'updated_at', 'name', 'logo_url', 'manager', 'ballpark', 'mascot', 'founded', 'wins', 'losses', 'win_percentage', 'revenue', 'color']},
        'draft' => {'only' => [PK_COLUMN.to_s, 'created_at', 'updated_at', 'date', 'round', 'pick', 'overall', 'college', 'notes']},
        'comments' => {'only' => [PK_COLUMN.to_s, 'content', 'created_at', 'updated_at']},
      },
    }
  end

  it 'allows to export to CSV with associations and default schema, containing properly translated header and follow configuration' do
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
    expect(csv.flatten).to include(@player.name + ' exported')
    expect(csv.flatten).to include(@player.team.name)
    expect(csv.flatten).to include(@player.draft.college)

    expect(csv.flatten.join(' ')).to include(@player.comments.first.content.split("\n").first.strip)
    expect(csv.flatten.join(' ')).to include(@player.comments.second.content.split("\n").first.strip)
  end

  it 'allows to export to JSON' do
    visit export_path(model_name: 'player')
    click_button 'Export to json'
    is_expected.to have_content @player.team.name
  end

  it 'allows to export to XML' do
    pending "Mongoid does not support to_xml's :include option" if CI_ORM == :mongoid
    visit export_path(model_name: 'player')
    click_button 'Export to xml'

    is_expected.to have_content @player.team.name
  end

  it 'exports polymorphic fields the easy way for now' do
    visit export_path(model_name: 'comment')
    select "<comma> ','", from: 'csv_options_generator_col_sep'
    click_button 'Export to csv'
    csv = CSV.parse page.driver.response.body
    expect(csv[0]).to match_array ['Id', 'Commentable', 'Commentable type', 'Content', 'Created at', 'Updated at']
    csv[1..-1].each do |line|
      expect(line[csv[0].index('Commentable')]).to eq(@player.id.to_s)
      expect(line[csv[0].index('Commentable type')]).to eq(@player.class.to_s)
    end
  end

  context 'with csv format' do
    it 'exports with modified schema' do
      page.driver.post(export_path(model_name: 'player', schema: @non_default_schema, csv: true, all: true, csv_options: {generator: {col_sep: ','}}))
      csv = CSV.parse page.driver.response.body
      expect(csv[0]).not_to include('Created at')
    end
  end

  it 'supports bulk export' do
    visit index_path(model_name: 'player')
    click_link 'Export found Players'
    is_expected.to have_content('Select fields to export')
  end
end
