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
      find('.boolean_type .fa-check').sibling('input').click
      click_button 'Save and edit'
      expect(field_test.reload.boolean_field).to be true
      find('.boolean_type .fa-times').sibling('input').click
      click_button 'Save and edit'
      expect(field_test.reload.boolean_field).to be false
      find('.boolean_type .fa-minus').sibling('input').click
      click_button 'Save and edit'
      expect(field_test.reload.boolean_field).to be nil
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
