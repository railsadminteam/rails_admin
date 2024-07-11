

require 'spec_helper'

RSpec.describe 'Dashboard action', type: :request do
  subject { page }

  it 'shows statistics by default' do
    allow(RailsAdmin.config(Player).abstract_model).to receive(:count).and_return(0)
    expect(RailsAdmin.config(Player).abstract_model).to receive(:count)
    visit dashboard_path
  end

  it 'does not show statistics if turned off' do
    RailsAdmin.config do |c|
      c.included_models = [Player]
      c.actions do
        dashboard do
          statistics false
        end
        index # mandatory
      end
    end

    expect(RailsAdmin.config(Player).abstract_model).not_to receive(:count)
    visit dashboard_path
  end

  it 'does not show history if turned off', active_record: true do
    RailsAdmin.config do |c|
      c.audit_with :paper_trail, 'User', 'PaperTrail::Version'
      c.included_models = [PaperTrailTest]
      c.actions do
        dashboard do
          history false
        end
        index # mandatory
        new
        history_index
      end
    end
    with_versioning do
      visit new_path(model_name: 'paper_trail_test')
      fill_in 'paper_trail_test[name]', with: 'Jackie Robinson'
      click_button 'Save'
    end
    visit dashboard_path
    is_expected.not_to have_content 'Jackie Robinson'
  end

  it 'counts are different for same-named models in different modules' do
    allow(RailsAdmin.config(User::Confirmed).abstract_model).to receive(:count).and_return(10)
    allow(RailsAdmin.config(Comment::Confirmed).abstract_model).to receive(:count).and_return(0)

    visit dashboard_path
    expect(find('tr.user_confirmed_links .progress').text).to eq '10'
    expect(find('tr.comment_confirmed_links .progress').text).to eq '0'
  end

  it 'most recent change dates are different for same-named models in different modules' do
    user_create = 10.days.ago
    comment_create = 20.days.ago
    FactoryBot.create(:user_confirmed, created_at: user_create)
    FactoryBot.create(:comment_confirmed, created_at: comment_create)

    visit dashboard_path
    expect(find('tr.user_confirmed_links')).to have_content '10 days ago'
    expect(find('tr.comment_confirmed_links')).to have_content '20 days ago'
  end

  describe 'I18n' do
    around do |example|
      I18n.config.available_locales = I18n.config.available_locales + [:xx]
      I18n.backend.class.send(:include, I18n::Backend::Pluralization)
      I18n.backend.store_translations :xx,
                                      admin: {
                                        misc: {
                                          ago: 'back',
                                        },
                                      },
                                      datetime: {
                                        distance_in_words: {
                                          x_days: {
                                            one: '1 day',
                                          },
                                        },
                                      }

      I18n.locale = :xx

      example.run

      I18n.locale = :en
      I18n.config.available_locales = I18n.config.available_locales - [:xx]
    end

    it "fallbacks to 'ago' when 'time_ago' is not available" do
      FactoryBot.create(:player, created_at: 1.day.ago)

      visit dashboard_path
      expect(page).to have_content '1 day back'
    end
  end
end
