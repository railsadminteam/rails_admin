# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'CKEditor field', type: :request do
  subject { page }

  # RailsAdmin provides no location any more, so the examples name one. 4.22.1 is
  # the last freely licensed release; it is a fixture here, not a recommendation.
  let(:base_location) { 'https://unpkg.com/ckeditor4@4.22.1/' }

  before { allow(RailsAdmin.deprecator).to receive(:warn) }

  it 'works without error', js: true do
    location = base_location
    RailsAdmin.config Draft do
      edit do
        field :notes, :ck_editor do
          base_location location
        end
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('#cke_draft_notes')
  end

  it 'leaves the textarea alone when no location is configured', js: true do
    allow(ConsoleLogger).to receive(:warn)
    RailsAdmin.config Draft do
      edit do
        field :notes, :ck_editor
      end
    end
    visit new_path(model_name: 'draft')
    is_expected.to have_selector('textarea#draft_notes')
    is_expected.not_to have_selector('#cke_draft_notes')
  end

  it 'writes back to the textarea when a remote-form modal is submitted', js: true do
    saved = save_through_modal(:ck_editor, base_location: base_location) do
      wait_for_editor %(!!(window.CKEDITOR && CKEDITOR.instances['#{editor_id}'] && CKEDITOR.instances['#{editor_id}'].status === 'ready'))
      execute_script %(CKEDITOR.instances['#{editor_id}'].insertHtml('<p>typed in the modal</p>'))
    end
    expect(saved).to include 'typed in the modal'
  end
end
