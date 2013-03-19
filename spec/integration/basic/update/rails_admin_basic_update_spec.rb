require 'spec_helper'

describe "RailsAdmin Basic Update" do

  subject { page }

  describe "update with errors" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
    end

    it "returns to edit page" do
      fill_in "player[name]", :with => ""
      click_button "Save" # first(:button, "Save").click
      expect(page.driver.status_code).to eq(406)
      should have_selector "form[action='#{edit_path(:model_name => "player", :id => @player.id)}']"
    end
  end

  describe "update and add another" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save" # first(:button, "Save").click

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "updates an object with correct attributes" do
      expect(@player.name).to eq("Jackie Robinson")
      expect(@player.number).to eq(42)
      expect(@player.position).to eq("Second baseman")
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save and edit"

      @player.reload
    end

    it "updates an object with correct attributes" do
      expect(@player.name).to eq("Jackie Robinson")
      expect(@player.number).to eq(42)
      expect(@player.position).to eq("Second baseman")
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @player = FactoryGirl.create :player
      @draft = FactoryGirl.create :draft
      @number = @draft.player.number + 1 # to avoid collision
      put edit_path(:model_name => "player", :id => @player.id, :player => {:name => "Jackie Robinson", :draft_id => @draft.id, :number => @number, :position => "Second baseman"})
      @player.reload
    end

    it "updates an object with correct attributes" do
      expect(@player.name).to eq("Jackie Robinson")
      expect(@player.number).to eq(@number)
      expect(@player.position).to eq("Second baseman")
    end

    it "updates an object with correct associations" do
      @draft.reload
      expect(@player.draft).to eq(@draft)
    end
  end

  describe "update with has-many association" do
    it "is fillable and emptyable", :active_record => true do
      RailsAdmin.config do |c|
        c.audit_with :history
      end

      @league = FactoryGirl.create :league
      @divisions = 3.times.map { Division.create!(:name => "div #{Time.now.to_f}", :league => League.create!(:name => "league #{Time.now.to_f}")) }

      put edit_path(:model_name => "league", :id => @league.id, :league => {:name => "National League", :division_ids => [@divisions[0].id] })

      old_name = @league.name
      @league.reload
      expect(@league.name).to eq("National League")
      @divisions[0].reload
      expect(@league.divisions).to include(@divisions[0])
      expect(@league.divisions).not_to include(@divisions[1])
      expect(@league.divisions).not_to include(@divisions[2])

      expect(RailsAdmin::History.where(:item => @league.id).collect(&:message)).to include("name: \"#{old_name}\" -> \"National League\"")

      put edit_path(:model_name => "league", :id => @league.id, :league => {:division_ids => [""]})

      @league.reload
      expect(@league.divisions).to be_empty
    end
  end

  describe "update with missing object" do
    before(:each) do
      put edit_path(:model_name => "player", :id => 1), :params => {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}}
    end

    it "raises NotFound" do
      expect(response.code).to eq("404")
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "a"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save" # first(:button, "Save").click

      @player.reload
    end

    it "shows an error message" do
      # TODO: Mongoid 3.0.0 lacks ability of numericality validation on Integer field.
      # This is caused by change in https://github.com/mongoid/mongoid/pull/1698
      # I believe this should be a bug in Mongoid.
      expect(Capybara.string(body)).to have_content("Player failed to be updated") unless CI_ORM == :mongoid && Mongoid::VERSION >= '3.0.0'
    end
  end

  describe "update with serialized objects" do
    before(:each) do
      RailsAdmin.config do |c|
        c.model User do
          configure :roles, :serialized
        end
      end

      @user = FactoryGirl.create :user

      visit edit_path(:model_name => "user", :id => @user.id)

      fill_in "user[roles]", :with => %{['admin', 'user']}
      click_button "Save" # first(:button, "Save").click

      @user.reload
    end

    it "saves the serialized data" do
      expect(@user.roles).to eq(['admin','user'])
    end
  end

  describe "update with serialized objects of Mongoid", :mongoid => true do
    before(:each) do
      @field_test = FactoryGirl.create :field_test

      visit edit_path(:model_name => "field_test", :id => @field_test.id)
    end

    it "saves the serialized data" do
      fill_in "field_test[array_field]", :with => "[4, 2]"
      fill_in "field_test[hash_field]", :with => "{ a: 6, b: 2 }"
      click_button "Save" # first(:button, "Save").click

      @field_test.reload
      expect(@field_test.array_field).to eq([4, 2])
      expect(@field_test.hash_field).to eq({ "a" => 6, "b" => 2 })
    end

    it "clears data when empty string is passed" do
      fill_in "field_test[array_field]", :with => ""
      fill_in "field_test[hash_field]", :with => ""
      click_button "Save" # first(:button, "Save").click

      @field_test.reload
      expect(@field_test.array_field).to eq(nil)
      expect(@field_test.hash_field).to eq(nil)
    end
  end

  describe "update with overridden to_param" do
    before(:each) do
      @ball = FactoryGirl.create :ball

      visit edit_path(:model_name => "ball", :id => @ball.id)

      fill_in "ball[color]", :with => "gray"
      click_button "Save and edit"

      @ball.reload
    end

    it "updates an object with correct attributes" do
      expect(@ball.color).to eq("gray")
    end
  end

  describe "update of STI subclass on superclass view" do
    before(:each) do
      @hardball = FactoryGirl.create :hardball

      visit edit_path(:model_name => "ball", :id => @hardball.id)

      fill_in "ball[color]", :with => "cyan"
      click_button "Save and edit"

      @hardball.reload
    end

    it "updates an object with correct attributes" do
      expect(@hardball.color).to eq("cyan")
    end
  end

end
