

require 'spec_helper'

RSpec.describe 'Time field', type: :request, active_record: true do
  subject { page }
  before do
    RailsAdmin.config FieldTest do
      edit do
        field :time_field
      end
    end
  end

  describe 'filtering' do
    let!(:field_tests) do
      [FactoryBot.create(:field_test, time_field: DateTime.new(2000, 1, 1, 3, 45)),
       FactoryBot.create(:field_test, time_field: DateTime.new(2000, 1, 1, 4, 45))]
    end

    it 'correctly returns a record' do
      visit index_path(model_name: 'field_test', f: {time_field: {'1' => {v: [nil, '2000-01-01T04:00:00', nil], o: 'between'}}})
      is_expected.to have_content '1 field test'
      is_expected.to have_content field_tests[1].id
    end

    it 'does not break when the condition is not filled' do
      visit index_path(model_name: 'field_test', f: {time_field: {'1' => {v: [nil, '', ''], o: 'between'}}})
      is_expected.to have_content '2 field test'
    end

    context 'with server timezone changed' do
      around do |example|
        original = Time.zone
        Time.zone = ActiveSupport::TimeZone.new('Central Time (US & Canada)')
        example.run
        Time.zone = original
      end

      it 'correctly returns a record' do
        visit index_path(model_name: 'field_test', f: {time_field: {'1' => {v: [nil, '2000-01-01T22:00:00', nil], o: 'between'}}})
        is_expected.to have_content '1 field test'
        is_expected.to have_content field_tests[1].id
      end
    end
  end

  context 'on create' do
    it 'is initially blank' do
      visit new_path(model_name: 'field_test')
      expect(find('[name="field_test[time_field]"]', visible: false).value).to be_blank
    end

    it 'persists the value' do
      visit new_path(model_name: 'field_test')
      find('[name="field_test[time_field]"]', visible: false).set('2000-01-01T03:45:00')
      click_button 'Save'
      expect(FieldTest.count).to eq 1
      expect(FieldTest.first.time_field).to eq DateTime.new(2000, 1, 1, 3, 45)
    end

    it 'ignores the date part' do
      visit new_path(model_name: 'field_test')
      find('[name="field_test[time_field]"]', visible: false).set('2021-01-02T03:45:00')
      click_button 'Save'
      expect(FieldTest.first.time_field).to eq DateTime.new(2000, 1, 1, 3, 45)
    end
  end

  context 'on update' do
    let(:field_test) { FactoryBot.create :field_test, time_field: DateTime.new(2021, 1, 2, 3, 45) }

    it 'updates the value' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      expect(find('[name="field_test[time_field]"]', visible: false).value).to eq '2000-01-01T03:45:00'
      find('[name="field_test[time_field]"]', visible: false).set('2021-02-03T04:55:00')
      click_button 'Save'
      field_test.reload
      expect(field_test.time_field).to eq DateTime.new(2000, 1, 1, 4, 55)
    end
  end

  context 'with server timezone changed' do
    let(:field_test) { FactoryBot.create :field_test, time_field: DateTime.new(2000, 1, 1, 6, 45) }

    around do |example|
      original = Time.zone
      Time.zone = ActiveSupport::TimeZone.new('Central Time (US & Canada)')
      example.run
      Time.zone = original
    end

    it 'treats the datetime set by the browser as local time' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      find('[name="field_test[time_field]"]', visible: false).set('2000-01-01T04:55:00')
      click_button 'Save'
      field_test.reload
      expect(field_test.time_field.iso8601).to eq '2000-01-01T04:55:00-06:00'
    end

    it 'is not altered by just saving untouched' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      expect(find('[name="field_test[time_field]"]', visible: false).value).to eq '2000-01-01T00:45:00'
      click_button 'Save'
      expect { field_test.reload }.not_to change(field_test, :time_field)
    end
  end
end
