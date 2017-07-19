require 'spec_helper'

describe 'RailsAdmin Config DSL Show Section', type: :request do
  subject { page }
  let(:team) { FactoryGirl.create :team }

  def do_request
    visit show_path(model_name: 'team', id: team.id)
  end

  describe 'JSON show view' do
    before do
      @player = FactoryGirl.create :player
      visit uri
    end

    let(:uri) { show_path(model_name: 'player', id: @player.id, format: :json) }
    let(:body) { page.body }

    it 'creates a JSON uri' do
      expect(uri).to eq("/admin/player/#{@player.id}.json")
    end

    it 'contains the JSONified object' do
      expect(JSON.parse(body)).to eq JSON.parse @player.reload.to_json
    end
  end

  describe 'compact_show_view' do
    it 'hides empty fields in show view by default' do
      do_request
      is_expected.not_to have_css('.logo_url_field')
    end

    it 'is disactivable' do
      RailsAdmin.config do |c|
        c.compact_show_view = false
      end

      do_request
      is_expected.to have_css('.logo_url_field')
    end
  end

  describe 'bindings' do
    it 'should be present' do
      RailsAdmin.config Team do |_c|
        show do
          field :name do
            show do
              bindings[:object] && bindings[:view] && bindings[:controller]
            end
          end
        end
      end

      do_request

      is_expected.to have_selector('dt .name_field.string_type')
    end
  end

  describe 'css hooks' do
    it 'is present' do
      do_request

      is_expected.to have_selector('dt .name_field.string_type')
    end
  end

  describe 'field groupings' do
    before do
      RailsAdmin.config do |c|
        c.compact_show_view = false
      end
    end

    it 'is hideable' do
      RailsAdmin.config Team do
        show do
          group :default do
            hide
          end
        end
      end

      do_request

      is_expected.not_to have_selector('h4', text: 'Basic info')

      %w(
        division name logo_url manager
        ballpark mascot founded wins
        losses win_percentage revenue
      ).each do |field|
        is_expected.not_to have_selector(".#{field}_field")
      end
    end

    it 'hides association groupings by the name of the association' do
      RailsAdmin.config Team do
        show do
          group :players do
            hide
          end
        end
      end

      do_request

      is_expected.not_to have_selector('h4', text: 'Players')
    end

    it 'is renameable' do
      RailsAdmin.config Team do
        show do
          group :default do
            label 'Renamed group'
          end
        end
      end

      do_request

      is_expected.to have_selector('h4', text: 'Renamed group')
    end

    it 'has accessor for its fields' do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :belongs_to_associations do
            label "Belong's to associations"
            field :division
          end
        end
      end

      do_request

      is_expected.to have_selector('h4', text: 'Basic info')
      is_expected.to have_selector('h4', text: "Belong's to associations")

      is_expected.to have_selector('.name_field')
      is_expected.to have_selector('.logo_url_field')
      is_expected.to have_selector('.division_field')
    end

    it 'has accessor for its fields by type' do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :other do
            field :division
            field :manager
            field :ballpark
            fields_of_type :string do
              label { "#{label} (STRING)" }
            end
          end
        end
      end

      do_request

      is_expected.to have_selector('.label', text: 'Name')
      is_expected.to have_selector('.label', text: 'Logo url')
      is_expected.to have_selector('.label', text: 'Division')
      is_expected.to have_selector('.label', text: 'Manager (STRING)')
      is_expected.to have_selector('.label', text: 'Ballpark (STRING)')
    end
  end

  describe "items' fields" do
    before do
      RailsAdmin.config do |c|
        c.compact_show_view = false
      end
    end

    it 'shows all by default' do
      do_request

      %w(
        division name logo_url manager
        ballpark mascot founded wins
        losses win_percentage revenue players fans
      ).each do |field|
        is_expected.to have_selector(".#{field}_field")
      end
    end

    it 'only shows the defined fields and appear in order defined' do
      RailsAdmin.config Team do
        show do
          field :manager
          field :division
          field :name
        end
      end

      do_request

      is_expected.to have_selector('.manager_field')
      is_expected.to have_selector('.division_field')
      is_expected.to have_selector('.name_field')
    end

    it 'delegates the label option to the ActiveModel API' do
      RailsAdmin.config Team do
        show do
          field :manager
          field :fans
        end
      end

      do_request

      is_expected.to have_selector('.label', text: 'Team Manager')
      is_expected.to have_selector('.label', text: 'Some Fans')
    end

    it 'is renameable' do
      RailsAdmin.config Team do
        show do
          field :manager do
            label 'Renamed field'
          end
          field :division
          field :name
        end
      end

      do_request

      is_expected.to have_selector('.label', text: 'Renamed field')
      is_expected.to have_selector('.label', text: 'Division')
      is_expected.to have_selector('.label', text: 'Name')
    end

    it 'is renameable by type' do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      [
        'Division', 'Name (STRING)', 'Logo url (STRING)', 'Manager (STRING)',
        'Ballpark (STRING)', 'Mascot (STRING)', 'Founded', 'Wins', 'Losses',
        'Win percentage', 'Revenue', 'Players', 'Fans'
      ].each do |text|
        is_expected.to have_selector('.label', text: text)
      end
    end

    it 'is globally renameable by type' do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      [
        'Division', 'Name (STRING)', 'Logo url (STRING)', 'Manager (STRING)',
        'Ballpark (STRING)', 'Mascot (STRING)', 'Founded', 'Wins', 'Losses',
        'Win percentage', 'Revenue', 'Players', 'Fans'
      ].each do |text|
        is_expected.to have_selector('.label', text: text)
      end
    end

    it 'is hideable' do
      RailsAdmin.config Team do
        show do
          field :manager do
            hide
          end
          field :division
          field :name
        end
      end

      do_request

      is_expected.to have_selector('.division_field')
      is_expected.to have_selector('.name_field')
    end

    it 'is hideable by type' do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      %w(Name Logo\ url Manager Ballpark Mascot).each do |text|
        is_expected.not_to have_selector('.label', text: text)
      end

      %w(Division Founded Wins Losses Win\ percentage Revenue Players Fans).each do |text|
        is_expected.to have_selector('.label', text: text)
      end
    end

    it 'is globally hideable by type' do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      %w(Name Logo\ url Manager Ballpark Mascot).each do |text|
        is_expected.not_to have_selector('.label', text: text)
      end

      %w(Division Founded Wins Losses Win\ percentage Revenue Players Fans).each do |text|
        is_expected.to have_selector('.label', text: text)
      end
    end
  end

  describe 'embedded model', mongoid: true do
    it "does not show link to individual object's page" do
      @record = FactoryGirl.create :field_test
      2.times.each { |i| @record.embeds.create name: "embed #{i}" }
      visit show_path(model_name: 'field_test', id: @record.id)
      is_expected.not_to have_link('embed 0')
      is_expected.not_to have_link('embed 1')
    end
  end

  describe 'virtual field' do
    let(:team) { FactoryGirl.create :team, name: 'foobar' }
    context 'with formatted_value defined' do
      before do
        RailsAdmin.config Team do
          show do
            field :truncated_name do
              formatted_value do
                bindings[:object].name.truncate(5)
              end
            end
          end
        end
      end

      it 'shows up correctly' do
        do_request

        is_expected.to have_selector('.truncated_name_field')
        is_expected.to have_selector('dd', text: 'fo...')
      end
    end

    context 'without formatted_value' do
      before do
        RailsAdmin.config Team do
          show do
            field :truncated_name do
              pretty_value do
                bindings[:object].name.truncate(5)
              end
            end
          end
        end
      end

      it 'raises error along with suggestion' do
        expect { do_request }.to raise_error(/you should declare 'formatted_value'/)
      end
    end
  end
end
