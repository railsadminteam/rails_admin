require 'spec_helper'

RSpec.describe 'Color field', type: :request do
  subject { page }

  it 'shows input with class color' do
    RailsAdmin.config Team do
      edit do
        field :color, :color
      end
    end
    visit new_path(model_name: 'team')
    is_expected.to have_selector('.color_type input')
  end
end
