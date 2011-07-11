require 'spec_helper'

describe "RailsAdmin Config DSL Show Section" do
  let(:team) { Factory.create :team }

  def do_request
    visit rails_admin_show_path(:model_name => "team", :id => team.id)
  end

  describe "field groupings" do
    it "should be hideable" do
      RailsAdmin.config Team do
        show do
          group :default do
            hide
          end
        end
      end

      do_request

      page.should_not have_selector("h4", :text => "Basic info")

      page.should_not have_selector("div.team_division_id")
      page.should_not have_selector("div.team_name")
      page.should_not have_selector("div.team_logo_url")
      page.should_not have_selector("div.team_manager")
      page.should_not have_selector("div.team_ballpark")
      page.should_not have_selector("div.team_mascot")
      page.should_not have_selector("div.team_founded")
      page.should_not have_selector("div.team_wins")
      page.should_not have_selector("div.team_losses")
      page.should_not have_selector("div.team_win_percentage")
      page.should_not have_selector("div.team_revenue")
    end

    it "should hide association groupings by the name of the association" do
      RailsAdmin.config Team do
        show do
          group :players do
            hide
          end
        end
      end

      do_request

      page.should_not have_selector("h4", :text => "Players")
    end

    it "should be renameable" do
      RailsAdmin.config Team do
        show do
          group :default do
            label "Renamed group"
          end
        end
      end

      do_request

      page.should have_selector("h4", :text => "Renamed group")
    end

    it "should have accessor for its fields" do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :belongs_to_associations do
            label "Belong's to associations"
            field :division_id
          end
        end
      end

      do_request

      page.should have_selector("h4", :text => "Basic info")
      page.should have_selector("h4", :text => "Belong's to associations")

      page.should have_selector(".team_name")
      page.should have_selector(".team_logo_url")
      page.should have_selector(".team_division_id")
    end

    it "should have accessor for its fields by type" do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :other do
            field :division_id
            field :manager
            field :ballpark
            fields_of_type :string do
              label { "#{label} (STRING)" }
            end
          end
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Name")
      page.should have_selector("div.label", :text => "Logo url")
      page.should have_selector("div.label", :text => "Division")
      page.should have_selector("div.label", :text => "Manager (STRING)")
      page.should have_selector("div.label", :text => "Ballpark (STRING)")
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      do_request

      page.should have_selector("div.team_division_id")
      page.should have_selector("div.team_name")
      page.should have_selector("div.team_logo_url")
      page.should have_selector("div.team_manager")
      page.should have_selector("div.team_ballpark")
      page.should have_selector("div.team_mascot")
      page.should have_selector("div.team_founded")
      page.should have_selector("div.team_wins")
      page.should have_selector("div.team_losses")
      page.should have_selector("div.team_win_percentage")
      page.should have_selector("div.team_revenue")
      page.should have_selector("div.team_players")
      page.should have_selector("div.team_fans")
    end

    it "should only show the defined fields and appear in order defined" do
      RailsAdmin.config Team do
        show do
          field :manager
          field :division_id
          field :name
        end
      end

      do_request

      page.should have_selector(".team_manager")
      page.should have_selector(".team_division_id")
      page.should have_selector(".team_name")
    end


    it "should delegates the label option to the ActiveModel API" do
      RailsAdmin.config Team do
        show do
          field :manager
          field :fans
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Team Manager")
      page.should have_selector("div.label", :text => "Some Fans")
    end

    it "should be renameable" do
      RailsAdmin.config Team do
        show do
          field :manager do
            label "Renamed field"
          end
          field :division_id
          field :name
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Renamed field")
      page.should have_selector("div.label", :text => "Division")
      page.should have_selector("div.label", :text => "Name")
    end

    it "should be renameable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Division")
      page.should have_selector("div.label", :text => "Name (STRING)")
      page.should have_selector("div.label", :text => "Logo url (STRING)")
      page.should have_selector("div.label", :text => "Manager (STRING)")
      page.should have_selector("div.label", :text => "Ballpark (STRING)")
      page.should have_selector("div.label", :text => "Mascot (STRING)")
      page.should have_selector("div.label", :text => "Founded")
      page.should have_selector("div.label", :text => "Wins")
      page.should have_selector("div.label", :text => "Losses")
      page.should have_selector("div.label", :text => "Win percentage")
      page.should have_selector("div.label", :text => "Revenue")
      page.should have_selector("div.label", :text => "Players")
      page.should have_selector("div.label", :text => "Fans")
    end

    it "should be globally renameable by type" do
      RailsAdmin::Config.models do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Division")
      page.should have_selector("div.label", :text => "Name (STRING)")
      page.should have_selector("div.label", :text => "Logo url (STRING)")
      page.should have_selector("div.label", :text => "Manager (STRING)")
      page.should have_selector("div.label", :text => "Ballpark (STRING)")
      page.should have_selector("div.label", :text => "Mascot (STRING)")
      page.should have_selector("div.label", :text => "Founded")
      page.should have_selector("div.label", :text => "Wins")
      page.should have_selector("div.label", :text => "Losses")
      page.should have_selector("div.label", :text => "Win percentage")
      page.should have_selector("div.label", :text => "Revenue")
      page.should have_selector("div.label", :text => "Players")
      page.should have_selector("div.label", :text => "Fans")

    end

    it "should be hideable" do
      RailsAdmin.config Team do
        show do
          field :manager do
            hide
          end
          field :division_id
          field :name
        end
      end

      do_request

      page.should have_selector(".team_division_id")
      page.should have_selector(".team_name")
    end

    it "should be hideable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Division")
      page.should_not have_selector("div.label", :text => "Name")
      page.should_not have_selector("div.label", :text => "Logo url")
      page.should_not have_selector("div.label", :text => "Manager")
      page.should_not have_selector("div.label", :text => "Ballpark")
      page.should_not have_selector("div.label", :text => "Mascot")
      page.should have_selector("div.label", :text => "Founded")
      page.should have_selector("div.label", :text => "Wins")
      page.should have_selector("div.label", :text => "Losses")
      page.should have_selector("div.label", :text => "Win percentage")
      page.should have_selector("div.label", :text => "Revenue")
      page.should have_selector("div.label", :text => "Players")
      page.should have_selector("div.label", :text => "Fans")

    end

    it "should be globally hideable by type" do
      RailsAdmin::Config.models do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      page.should have_selector("div.label", :text => "Division")
      page.should_not have_selector("div.label", :text => "Name")
      page.should_not have_selector("div.label", :text => "Logo url")
      page.should_not have_selector("div.label", :text => "Manager")
      page.should_not have_selector("div.label", :text => "Ballpark")
      page.should_not have_selector("div.label", :text => "Mascot")
      page.should have_selector("div.label", :text => "Founded")
      page.should have_selector("div.label", :text => "Wins")
      page.should have_selector("div.label", :text => "Losses")
      page.should have_selector("div.label", :text => "Win percentage")
      page.should have_selector("div.label", :text => "Revenue")
      page.should have_selector("div.label", :text => "Players")
      page.should have_selector("div.label", :text => "Fans")
    end
  end

  describe "Paperclip Support" do
    before do
      @user = Factory.create(:user)
    end

    it "when file is available, should show the image file" do
      RailsAdmin.config User do
        show do
          field :avatar
        end
      end

      @user.avatar_file_name = "1.jpg"
      @user.save!

      visit rails_admin_show_path(:model_name => "user", :id => @user.id)

      page.should have_selector("div.user_avatar div.value img[src='#{@user.avatar.url}']")
    end

    it "when file is not available, should show 'No File Found'" do
      RailsAdmin.config User do
        show do
          field :avatar
        end
      end

      visit rails_admin_show_path(:model_name => "user", :id => @user.id)

      page.should have_selector("div.value", :text => "No file found")
    end
  end
end
