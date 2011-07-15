require 'spec_helper'

describe "RailsAdmin Config DSL Show Section" do
  subject { page }
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

      should_not have_selector("h4", :text => "Basic info")

      should_not have_selector("div.team_division_id")
      should_not have_selector("div.team_name")
      should_not have_selector("div.team_logo_url")
      should_not have_selector("div.team_manager")
      should_not have_selector("div.team_ballpark")
      should_not have_selector("div.team_mascot")
      should_not have_selector("div.team_founded")
      should_not have_selector("div.team_wins")
      should_not have_selector("div.team_losses")
      should_not have_selector("div.team_win_percentage")
      should_not have_selector("div.team_revenue")
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

      should_not have_selector("h4", :text => "Players")
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

      should have_selector("h4", :text => "Renamed group")
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

      should have_selector("h4", :text => "Basic info")
      should have_selector("h4", :text => "Belong's to associations")

      should have_selector(".team_name")
      should have_selector(".team_logo_url")
      should have_selector(".team_division_id")
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

      should have_selector("div.label", :text => "Name")
      should have_selector("div.label", :text => "Logo url")
      should have_selector("div.label", :text => "Division")
      should have_selector("div.label", :text => "Manager (STRING)")
      should have_selector("div.label", :text => "Ballpark (STRING)")
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      do_request

      should have_selector("div.team_division_id")
      should have_selector("div.team_name")
      should have_selector("div.team_logo_url")
      should have_selector("div.team_manager")
      should have_selector("div.team_ballpark")
      should have_selector("div.team_mascot")
      should have_selector("div.team_founded")
      should have_selector("div.team_wins")
      should have_selector("div.team_losses")
      should have_selector("div.team_win_percentage")
      should have_selector("div.team_revenue")
      should have_selector("div.team_players")
      should have_selector("div.team_fans")
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

      should have_selector(".team_manager")
      should have_selector(".team_division_id")
      should have_selector(".team_name")
    end


    it "should delegates the label option to the ActiveModel API" do
      RailsAdmin.config Team do
        show do
          field :manager
          field :fans
        end
      end

      do_request

      should have_selector("div.label", :text => "Team Manager")
      should have_selector("div.label", :text => "Some Fans")
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

      should have_selector("div.label", :text => "Renamed field")
      should have_selector("div.label", :text => "Division")
      should have_selector("div.label", :text => "Name")
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

      should have_selector("div.label", :text => "Division")
      should have_selector("div.label", :text => "Name (STRING)")
      should have_selector("div.label", :text => "Logo url (STRING)")
      should have_selector("div.label", :text => "Manager (STRING)")
      should have_selector("div.label", :text => "Ballpark (STRING)")
      should have_selector("div.label", :text => "Mascot (STRING)")
      should have_selector("div.label", :text => "Founded")
      should have_selector("div.label", :text => "Wins")
      should have_selector("div.label", :text => "Losses")
      should have_selector("div.label", :text => "Win percentage")
      should have_selector("div.label", :text => "Revenue")
      should have_selector("div.label", :text => "Players")
      should have_selector("div.label", :text => "Fans")
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

      should have_selector("div.label", :text => "Division")
      should have_selector("div.label", :text => "Name (STRING)")
      should have_selector("div.label", :text => "Logo url (STRING)")
      should have_selector("div.label", :text => "Manager (STRING)")
      should have_selector("div.label", :text => "Ballpark (STRING)")
      should have_selector("div.label", :text => "Mascot (STRING)")
      should have_selector("div.label", :text => "Founded")
      should have_selector("div.label", :text => "Wins")
      should have_selector("div.label", :text => "Losses")
      should have_selector("div.label", :text => "Win percentage")
      should have_selector("div.label", :text => "Revenue")
      should have_selector("div.label", :text => "Players")
      should have_selector("div.label", :text => "Fans")

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

      should have_selector(".team_division_id")
      should have_selector(".team_name")
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

      should have_selector("div.label", :text => "Division")
      should_not have_selector("div.label", :text => "Name")
      should_not have_selector("div.label", :text => "Logo url")
      should_not have_selector("div.label", :text => "Manager")
      should_not have_selector("div.label", :text => "Ballpark")
      should_not have_selector("div.label", :text => "Mascot")
      should have_selector("div.label", :text => "Founded")
      should have_selector("div.label", :text => "Wins")
      should have_selector("div.label", :text => "Losses")
      should have_selector("div.label", :text => "Win percentage")
      should have_selector("div.label", :text => "Revenue")
      should have_selector("div.label", :text => "Players")
      should have_selector("div.label", :text => "Fans")

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

      should have_selector("div.label", :text => "Division")
      should_not have_selector("div.label", :text => "Name")
      should_not have_selector("div.label", :text => "Logo url")
      should_not have_selector("div.label", :text => "Manager")
      should_not have_selector("div.label", :text => "Ballpark")
      should_not have_selector("div.label", :text => "Mascot")
      should have_selector("div.label", :text => "Founded")
      should have_selector("div.label", :text => "Wins")
      should have_selector("div.label", :text => "Losses")
      should have_selector("div.label", :text => "Win percentage")
      should have_selector("div.label", :text => "Revenue")
      should have_selector("div.label", :text => "Players")
      should have_selector("div.label", :text => "Fans")
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

      should have_selector("div.user_avatar div.value img[src='#{@user.avatar.url}']")
    end

    it "when file is not available, should show 'No File Found'" do
      RailsAdmin.config User do
        show do
          field :avatar
        end
      end

      visit rails_admin_show_path(:model_name => "user", :id => @user.id)

      should have_selector("div.value", :text => "No file found")
    end
  end
end
