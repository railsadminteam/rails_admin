

require 'spec_helper'

RSpec.describe 'Hidden field', type: :request do
  subject { page }

  describe '#default_value' do
    before do
      RailsAdmin::Config.authenticate_with { warden.authenticate! scope: :user }
      RailsAdmin::Config.current_user_method(&:current_user)
      login_as User.create(
        email: 'username@example.com',
        password: 'password',
      )
    end

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

    it 'submits the field value' do
      visit new_path(model_name: 'player')
      find("#player_name[type=hidden][value='username@example.com']", visible: false).set('someone@example.com')
      fill_in 'Number', with: 1
      click_button 'Save'
      is_expected.to have_content('Player successfully created')
      expect(Player.first.name).to eq 'someone@example.com'
    end
  end
end
