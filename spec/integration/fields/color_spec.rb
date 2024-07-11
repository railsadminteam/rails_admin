

require 'spec_helper'

RSpec.describe 'Color field', type: :request do
  subject { page }

  it 'uses HTML5 color picker' do
    RailsAdmin.config Team do
      field :color, :color
    end
    visit new_path(model_name: 'team')
    is_expected.to have_selector('#team_color[type="color"]')
  end
end
