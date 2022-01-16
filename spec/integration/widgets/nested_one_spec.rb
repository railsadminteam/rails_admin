require 'spec_helper'

RSpec.describe 'Nested one widget', type: :request, js: true do
  subject { page }

  let(:field_test) { FactoryBot.create :field_test }
  before do
    RailsAdmin.config(FieldTest) do
      field :comment
    end
  end

  it 'adds an nested item' do
    visit edit_path(model_name: 'field_test', id: field_test.id)

    find('#field_test_comment_attributes_field .add_nested_fields').click
    fill_in 'field_test_comment_attributes_content', with: 'nested comment content'

    # trigger click via JS, workaround for instability in CI
    execute_script %(document.querySelector('button[name="_save"]').click())
    is_expected.to have_content('Field test successfully updated')

    expect(field_test.reload.comment.content.strip).to eq('nested comment content')
  end

  it 'deletes the nested item' do
    FactoryBot.create :comment, commentable: field_test
    visit edit_path(model_name: 'field_test', id: field_test.id)

    find('.comment_field .toggler').click
    find('.comment_field .remove_nested_fields', visible: false).click

    # trigger click via JS, workaround for instability in CI
    execute_script %(document.querySelector('button[name="_save"]').click())
    is_expected.to have_content('Field test successfully updated')

    expect(field_test.reload.comment).to be nil
  end

  it 'is optional' do
    visit edit_path(model_name: 'field_test', id: field_test.id)
    click_button 'Save'
    expect(field_test.reload.comment).to be_nil
  end

  context 'when XSS attack is attempted' do
    it 'does not break on adding a new item' do
      allow(I18n).to receive(:t).and_call_original
      expect(I18n).to receive(:t).with('admin.form.new_model', name: 'Comment').and_return('<script>throw "XSS";</script>')
      visit edit_path(model_name: 'field_test', id: field_test.id)
      find('#field_test_comment_attributes_field .add_nested_fields').click
    end

    it 'does not break on adding an existing item' do
      RailsAdmin.config Comment do
        object_label_method :content
      end
      FactoryBot.create :comment, content: '<script>throw "XSS";</script>', commentable: field_test
      visit edit_path(model_name: 'field_test', id: field_test.id)
    end
  end

  context 'when the nested field contains a required field' do
    before do
      RailsAdmin.config Comment do
        configure :content do
          required true
        end
      end
    end

    it 'is not affected by form required validation' do
      FactoryBot.create :comment, commentable: field_test, content: ''
      visit edit_path(model_name: 'field_test', id: field_test.id)

      find('.comment_field .toggler').click
      find('.comment_field .remove_nested_fields', visible: false).click

      # trigger click via JS, workaround for instability in CI
      execute_script %(document.querySelector('button[name="_save"]').click())
      is_expected.to have_content('Field test successfully updated')

      expect(field_test.reload.comment).to be nil
    end
  end
end
