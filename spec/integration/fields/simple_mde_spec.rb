

require 'spec_helper'

RSpec.describe 'SimpleMDE field', type: :request do
  subject { page }

  it 'works without error', js: true do
    RailsAdmin.config Draft do
      edit do
        field :notes, :simple_mde
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('a[title="Markdown Guide"]')
  end
end
