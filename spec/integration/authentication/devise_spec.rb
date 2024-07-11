

require 'spec_helper'

RSpec.describe 'RailsAdmin Devise Authentication', type: :request do
  subject { page }
  let!(:user) { FactoryBot.create :user }

  before do
    RailsAdmin.config do |config|
      config.authenticate_with do
        warden.authenticate! scope: :user
      end
      config.current_user_method(&:current_user)
    end
  end

  it 'supports logging-in', js: true do
    visit dashboard_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    is_expected.to have_css 'body.rails_admin'
  end

  it 'supports logging-out', js: true do
    login_as user
    visit dashboard_path
    click_link 'Log out'
    is_expected.to have_content 'Log in'
  end
end
