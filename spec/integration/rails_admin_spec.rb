require 'spec_helper'

describe RailsAdmin, type: :request do
  subject { page }

  before do
    RailsAdmin::Config.authenticate_with { warden.authenticate! scope: :user }
    RailsAdmin::Config.current_user_method(&:current_user)
    login_as User.create(
      email: 'username@example.com',
      password: 'password',
    )
  end

  # A common mistake for translators is to forget to change the YAML file's
  # root key from en to their own locale (as people tend to use the English
  # file as template for a new translation).
  describe 'localization' do
    it 'defaults to English' do
      RailsAdmin.config.included_models = []
      visit dashboard_path

      is_expected.to have_content('Site Administration')
      is_expected.to have_content('Dashboard')
    end
  end

  describe 'html head' do
    before { visit dashboard_path }

    # Note: the [href^="/asset... syntax matches the start of a value. The reason
    # we just do that is to avoid being confused by rails' asset_ids.
    it 'loads stylesheets in header' do
      is_expected.to have_selector('head link[href^="/assets/rails_admin/rails_admin"][href$=".css"]', visible: false)
    end

    it 'loads javascript files in body' do
      is_expected.to have_selector('head script[src^="/assets/rails_admin/rails_admin"][src$=".js"]', visible: false)
    end
  end

  describe 'hidden fields with default values' do
    before do
      RailsAdmin.config Player do
        include_all_fields
        edit do
          field :name, :hidden do
            default_value do
              bindings[:view]._current_user.email
            end
          end
        end
      end
    end

    it 'shows up with default value, hidden' do
      visit new_path(model_name: 'player')
      is_expected.to have_selector("#player_name[type=hidden][value='username@example.com']", visible: false)
      is_expected.not_to have_selector("#player_name[type=hidden][value='toto@example.com']", visible: false)
    end

    it 'does not show label' do
      is_expected.not_to have_selector('label', text: 'Name')
    end

    it 'does not show help block' do
      is_expected.not_to have_xpath("id('player_name')/../p[@class='help-block']")
    end
  end

  describe '_current_user' do # https://github.com/sferik/rails_admin/issues/549
    it 'is accessible from the list view' do
      RailsAdmin.config Player do
        list do
          field :name do
            visible do
              bindings[:view]._current_user.email == 'username@example.com'
            end
          end

          field :team do
            visible do
              bindings[:view]._current_user.email == 'foo@example.com'
            end
          end
        end
      end

      visit index_path(model_name: 'player')
      is_expected.to have_selector('.header.name_field')
      is_expected.not_to have_selector('.header.team_field')
    end
  end

  describe 'polymorphic associations' do
    before :each do
      @team = FactoryGirl.create :team
      @comment = FactoryGirl.create :comment, commentable: @team
    end

    it 'works like belongs to associations in the list view' do
      visit index_path(model_name: 'comment')

      is_expected.to have_content(@team.name)
    end

    it 'is editable' do
      visit edit_path(model_name: 'comment', id: @comment.id)

      is_expected.to have_selector('select#comment_commentable_type')
      is_expected.to have_selector('select#comment_commentable_id')
    end

    it 'is visible in the owning end' do
      visit edit_path(model_name: 'team', id: @team.id)

      is_expected.to have_selector('select#team_comment_ids')
    end
  end

  describe 'secondary navigation' do
    it 'has Gravatar image' do
      visit dashboard_path
      is_expected.to have_selector('ul.navbar-right img[src*="gravatar.com"]')
    end

    it "does not show Gravatar when user doesn't have email method" do
      allow_any_instance_of(User).to receive(:respond_to?).and_return(true)
      allow_any_instance_of(User).to receive(:respond_to?).with(:email).and_return(false)
      allow_any_instance_of(User).to receive(:respond_to?).with(:devise_scope).and_return(false)
      visit dashboard_path
      is_expected.not_to have_selector('ul.nav.pull-right li img')
    end

    it 'does not cause error when email is nil' do
      allow_any_instance_of(User).to receive(:email).and_return(nil)
      visit dashboard_path
      is_expected.to have_selector('body.rails_admin')
    end

    it 'shows a log out link' do
      visit dashboard_path
      is_expected.to have_content 'Log out'
    end

    it 'has label-danger class on log out link' do
      visit dashboard_path
      is_expected.to have_selector('.label-danger')
    end
  end

  describe 'CSRF protection' do
    before do
      allow_any_instance_of(ActionController::Base).to receive(:protect_against_forgery?).and_return(true)
    end

    it 'is enforced' do
      visit new_path(model_name: 'league')
      fill_in 'league[name]', with: 'National league'
      find('input[name="authenticity_token"]', visible: false).set("invalid token")
      expect { click_button 'Save' }.to raise_error ActionController::InvalidAuthenticityToken
    end
  end
end
