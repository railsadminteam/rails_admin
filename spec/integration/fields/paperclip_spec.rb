

require 'spec_helper'

RSpec.describe 'Paperclip field', type: :request do
  subject { page }

  it 'shows a file upload field' do
    RailsAdmin.config User do
      edit do
        field :avatar
      end
    end
    visit new_path(model_name: 'user')
    is_expected.to have_selector('input#user_avatar')
  end
end
