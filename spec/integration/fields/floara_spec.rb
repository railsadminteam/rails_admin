# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Floara field', type: :request do
  subject { page }

  it 'works without error', js: true do
    RailsAdmin.config Draft do
      edit do
        field :notes, :froala
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('.fr-box')
  end

  it 'should include custom froala configuration' do
    RailsAdmin.config Draft do
      edit do
        field :notes, :froala do
          config_options inlineMode: false
          css_location 'stub_css.css'
          js_location 'stub_js.js'
        end
      end
    end

    visit new_path(model_name: 'draft')
    is_expected.to have_selector('textarea#draft_notes[data-richtext="froala-wysiwyg"][data-options]')
  end

  it 'writes back to the textarea when a remote-form modal is submitted', js: true do
    saved = save_through_modal(:froala) do
      wait_for_editor %(!!(window.jQuery && jQuery.fn.froalaEditor && jQuery('##{editor_id}').data('froala.editor')))
      execute_script %(jQuery('##{editor_id}').froalaEditor('html.set', '<p>typed in the modal</p>'))
    end
    expect(saved).to include 'typed in the modal'
  end
end
