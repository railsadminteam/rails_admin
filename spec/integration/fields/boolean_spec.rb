

require 'spec_helper'

RSpec.describe 'Boolean field', type: :request do
  subject { page }
  let(:field_test) { FactoryBot.create :field_test }

  context 'if nullable' do
    before do
      RailsAdmin.config FieldTest do
        field :boolean_field
      end
    end

    it 'shows 3 radio buttons' do
      visit new_path(model_name: 'field_test')
      is_expected.to have_content 'New Field test'
      expect(all('[name="field_test[boolean_field]"]').map { |e| e['value'] }).to eq ['1', '0', '']
    end

    it 'can be updated' do
      visit edit_path(model_name: 'field_test', id: field_test.id)

      # change the value to true and assert the values
      find('.boolean_type label.success').click
      click_button 'Save and edit'
      # validate that the success button rendered and is active
      expect(page).to have_selector('.boolean_type input[value="1"][checked]')
      # validate the value is true
      expect(field_test.reload.boolean_field).to be true

      # change the value to false and assert the values
      find('.boolean_type label.danger').click
      click_button 'Save and edit'
      expect(page).to have_selector('.boolean_type input[value="0"][checked]')
      expect(field_test.reload.boolean_field).to be false

      # change the value to nil and assert the values
      find('.boolean_type label.default').click
      click_button 'Save and edit'
      expect(page).to have_selector('.boolean_type input[value=""][checked]')
      expect(field_test.reload.boolean_field).to be nil
    end
  end

  context 'when the boolean is in an embedded document' do
    before do
      RailsAdmin.config FieldTest do
        field :comment
      end

      RailsAdmin.config Comment do
        field :content, :boolean
      end
    end

    it 'can be updated', js: true do
      visit edit_path(model_name: 'field_test', id: field_test.id)

      # toggle open the embedded document section
      find('#field_test_comment_attributes_field .add_nested_fields').click
      # set the value to false and assert the values
      find('.boolean_type label.danger').click
      click_button 'Save and edit'
      expect(field_test.reload.comment.content).to eq '0'
    end
  end

  context 'if not nullable' do
    before do
      RailsAdmin.config FieldTest do
        field :boolean_field do
          nullable false
        end
      end
    end

    it 'shows a checkbox' do
      visit new_path(model_name: 'field_test')
      is_expected.to have_content 'New Field test'
      is_expected.to have_css '[type="checkbox"][name="field_test[boolean_field]"]'
    end

    it 'can be updated' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      find('.boolean_type input').check
      click_button 'Save and edit'
      expect(field_test.reload.boolean_field).to be true
      find('.boolean_type input').uncheck
      click_button 'Save and edit'
      expect(field_test.reload.boolean_field).to be false
    end
  end
end
