# frozen_string_literal: true

module RichTextEditorHelper
  # The textarea every rich-text example drives, through #save_through_modal.
  def editor_id
    'field_test_text_field'
  end

  # Fill a rich-text field through the remote-form modal and return what was
  # saved. The modal posts the form without firing a native submit, which is
  # when editors normally write back to their textarea - so it is the path an
  # editor's write-back has to be proven on.
  def save_through_modal(field_type)
    RailsAdmin.config NestedFieldTest do
      field :field_test
    end
    RailsAdmin.config FieldTest do
      field :text_field, field_type
    end

    visit new_path(model_name: 'nested_field_test')
    click_link 'Add a new Field test'
    expect(page).to have_content 'New Field test'
    yield
    find('#modal .save-action').click
    expect(page).to have_css('option', text: /FieldTest #/, visible: false)
    FieldTest.last.text_field.to_s
  end

  # Editors set themselves up asynchronously; wait until one can be driven.
  def wait_for_editor(ready)
    Timeout.timeout(20) { sleep 0.1 until evaluate_script(ready) }
  end
end

RSpec.configure do |config|
  config.include RichTextEditorHelper, type: :request
end
