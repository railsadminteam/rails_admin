

require 'spec_helper'

RSpec.describe 'CKEditor field', type: :request do
  subject { page }

  it 'works without error', js: true do
    RailsAdmin.config Draft do
      edit do
        field :notes, :ck_editor
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('#cke_draft_notes')
  end
end
