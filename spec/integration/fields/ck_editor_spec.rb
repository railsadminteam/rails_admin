# frozen_string_literal: true

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

  it 'supports focusing on sub-modals', js: true do
    RailsAdmin.config Comment do
      edit do
        field :content, :ck_editor
      end
    end
    visit new_path(model_name: 'player')
    find_link('Add a new Comment').trigger 'click'
    expect(page).to have_text 'New Comment'
    expect(page).to have_css '.cke_button__link'
    find('.cke_button__link').click
    expect(page).to have_css '.cke_dialog_ui_input_text'
    first(:css, '.cke_dialog_ui_input_text').click
    expect(page).to have_css '.cke_dialog_ui_input_text:focus'
  end
end
