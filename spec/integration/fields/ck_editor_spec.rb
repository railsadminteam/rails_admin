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

  it 'writes back to the textarea when a remote-form modal is submitted', js: true do
    saved = save_through_modal(:ck_editor) do
      wait_for_editor %(!!(window.CKEDITOR && CKEDITOR.instances['#{editor_id}'] && CKEDITOR.instances['#{editor_id}'].status === 'ready'))
      execute_script %(CKEDITOR.instances['#{editor_id}'].insertHtml('<p>typed in the modal</p>'))
    end
    expect(saved).to include 'typed in the modal'
  end
end
