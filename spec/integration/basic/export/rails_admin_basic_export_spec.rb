require 'spec_helper'
require 'csv'

describe "RailsAdmin Export" do

  subject { page }

  before(:each) do
    Comment.all.map &:destroy # rspec bug => doesn't get destroyed with transaction

    @players = 4.times.map { FactoryGirl.create :player }
    @player = @players.first
    @player.team = FactoryGirl.create :team
    @player.draft = FactoryGirl.create :draft
    @player.comments = (@comments = 2.times.map { FactoryGirl.create(:comment) })
    @player.save

    @abstract_model = RailsAdmin::AbstractModel.new(Player)

    # removed schema=>only=>created_at
    @non_default_schema = {
      "only"=>[PK_COLUMN.to_s, "updated_at", "deleted_at", "name", "position", "number", "retired", "injured", "born_on", "notes", "suspended"],
      "include"=>{
        "team"=>{"only"=>[PK_COLUMN.to_s, "created_at", "updated_at", "name", "logo_url", "manager", "ballpark", "mascot", "founded", "wins", "losses", "win_percentage", "revenue", "color"]},
        "draft"=>{"only"=>[PK_COLUMN.to_s, "created_at", "updated_at", "date", "round", "pick", "overall", "college", "notes"]},
        "comments"=>{"only"=>[PK_COLUMN.to_s, "content", "created_at", "updated_at"]}
      }
    }
  end

  describe "POST /admin/players/export (prompt)" do

    it "allows to export to CSV with associations and default schema, containing properly translated header and follow configuration" do
      RailsAdmin.config do |c|
        c.model Player do
          include_all_fields
          field :name do
            export_value do
              "#{value} exported"
            end
          end
        end
      end

      visit export_path(:model_name => 'player')
      should have_content 'Select fields to export'
      select "<comma> ','", :from => "csv_options_generator_col_sep"
      click_button 'Export to csv'
      csv = CSV.parse page.driver.response.body.force_encoding("utf-8") # comes through as us-ascii on some platforms
      expect(csv[0]).to match_array ["Id", "Created at", "Updated at", "Deleted at", "Name", "Position",
        "Number", "Retired", "Injured", "Born on", "Notes", "Suspended", "Id [Team]", "Created at [Team]",
        "Updated at [Team]", "Name [Team]", "Logo url [Team]", "Team Manager [Team]", "Ballpark [Team]",
        "Mascot [Team]", "Founded [Team]", "Wins [Team]", "Losses [Team]", "Win percentage [Team]",
        "Revenue [Team]", "Color [Team]", "Custom field [Team]", "Id [Draft]", "Created at [Draft]",
        "Updated at [Draft]", "Date [Draft]", "Round [Draft]", "Pick [Draft]", "Overall [Draft]",
        "College [Draft]", "Notes [Draft]", "Id [Comments]", "Content [Comments]", "Created at [Comments]",
        "Updated at [Comments]"]
      expect(csv.flatten).to include(@player.name + " exported")
      expect(csv.flatten).to include(@player.team.name)
      expect(csv.flatten).to include(@player.draft.college)

      expect(csv.flatten.join(' ')).to include(@player.comments.first.content.split("\n").first.strip)
      expect(csv.flatten.join(' ')).to include(@player.comments.second.content.split("\n").first.strip)
    end

    it "allows to export to JSON" do
      visit export_path(:model_name => 'player')
      click_button 'Export to json'
      should have_content @player.team.name
    end

    it "allows to export to XML" do
      visit export_path(:model_name => 'player')
      click_button 'Export to xml'

      # spec fails on non 1.9 mri rubies because of this https://github.com/rails/rails/pull/2076
      # waiting for fix (rails-3.1.4?)
      # and Mongoid with ActiveModel 3.1 does not support to_xml's :include options
      # (due change of implementation in ActiveModel::Serializers between 3.1 and 3.2)
      if RUBY_VERSION =~ /1\.9/ &&
          (CI_ORM != :mongoid || (CI_ORM == :mongoid && ActiveModel::VERSION::STRING >= "3.2"))
        should have_content @player.team.name
      end
    end

    it "exports polymorphic fields the easy way for now" do
      visit export_path(:model_name => 'comment')
      select "<comma> ','", :from => "csv_options_generator_col_sep"
      click_button 'Export to csv'
      csv = CSV.parse page.driver.response.body
      expect(csv[0]).to match_array ["Id", "Commentable", "Commentable type", "Content", "Created at", "Updated at"]
      csv[1..-1].each do |line|
        expect(line[csv[0].index('Commentable')]).to eq(@player.id.to_s)
        expect(line[csv[0].index('Commentable type')]).to eq(@player.class.to_s)
      end
    end
  end

  describe "POST /admin/players/export :format => :csv" do
    it "exports with modified schema" do
      page.driver.post(export_path(:model_name => 'player', :schema => @non_default_schema, :csv => true, :all => true, :csv_options => { :generator => { :col_sep => "," } }))
      csv = CSV.parse find('body').text
      expect(csv[0]).not_to include('Created at')
    end
  end
end
