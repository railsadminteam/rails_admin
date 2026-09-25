# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'CodeMirror field', type: :request do
  subject { page }

  it 'works without error', js: true do
    RailsAdmin.config Draft do
      edit do
        field :notes, :code_mirror
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('.CodeMirror')
  end

  it 'writes back to the textarea when a remote-form modal is submitted', js: true do
    saved = save_through_modal(:code_mirror) do
      wait_for_editor %(!!(document.querySelector('.CodeMirror') && document.querySelector('.CodeMirror').CodeMirror))
      execute_script %(document.querySelector('.CodeMirror').CodeMirror.setValue('typed in the modal'))
    end
    expect(saved).to include 'typed in the modal'
  end
end
