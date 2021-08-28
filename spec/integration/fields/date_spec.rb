require 'spec_helper'

RSpec.describe 'Date field', type: :request do
  subject { page }
  before do
    RailsAdmin.config FieldTest do
      field :id
      field :date_field
    end
  end

  describe 'Bootstrap Datetimepicker integration' do
    describe 'for form' do
      before { visit new_path({model_name: 'field_test'}.merge(params)) }
      let(:params) { {} }

      it 'is initially blank', js: true do
        expect(find('[name="field_test[date_field]"]', visible: false).value).to be_blank
        expect(find('#field_test_date_field').value).to be_blank
      end

      it 'populates the value selected by the Datetime picker into the hidden_field', js: true do
        page.execute_script <<-JS
          $('#field_test_date_field').data("DateTimePicker").date(moment('2015-10-08')).toggle();
        JS
        expect(find('#field_test_date_field').value).to eq 'October 08, 2015'
        expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2015-10-08T00:00:00'
      end

      it 'ignores the time part', js: true do
        page.execute_script <<-JS
          $('#field_test_date_field').data("DateTimePicker").date(moment('2015-10-08 12:00:00')).toggle();
        JS
        expect(find('#field_test_date_field').value).to eq 'October 08, 2015'
      end

      it 'populates the value entered in the text field into the hidden_field', js: true do
        fill_in 'Date field', with: 'January 2, 2021'
        expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2021-01-02T00:00:00'
        expect(find('#field_test_date_field').value).to eq 'January 02, 2021'
      end

      context 'with locale set' do
        around(:each) do |example|
          original = I18n.default_locale
          I18n.default_locale = :fr
          example.run
          I18n.default_locale = original
        end
        let(:params) { {field_test: {date_field: '2021-01-02T00:00:00'}} }

        it 'shows and accepts the value in the given locale', js: true do
          expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2021-01-02T00:00:00'
          expect(find('#field_test_date_field').value).to eq "2 janvier 2021"
          fill_in 'Date field', with: '3 février 2021'
          expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2021-02-03T00:00:00'
        end
      end
    end

    describe 'for filter' do
      it 'populates the value selected by the Datetime picker into the hidden_field', js: true do
        visit index_path(model_name: 'field_test')
        click_link 'Add filter'
        click_link 'Date field'
        expect(find('[name^="f[date_field]"][name$="[v][]"]', match: :first, visible: false).value).to be_blank
        page.execute_script <<-JS
          $('.form-control.date').data("DateTimePicker").date(moment('2015-10-08')).toggle();
        JS
        expect(find('[name^="f[date_field]"][name$="[v][]"]', match: :first, visible: false).value).to eq '2015-10-08T00:00:00'
      end
    end
  end

  describe 'filtering' do
    let!(:field_tests) do
      [FactoryBot.create(:field_test, date_field: Date.new(2021, 1, 2)),
       FactoryBot.create(:field_test, date_field: Date.new(2021, 1, 3))]
    end

    it 'correctly returns a record' do
      visit index_path(model_name: 'field_test', f: {date_field: {'1' => {v: [nil, '2021-01-03T00:00:00', nil], o: 'between'}}})
      is_expected.to have_content '1 field test'
      is_expected.to have_content field_tests[1].id
    end

    it 'does not break when the condition is not filled' do
      visit index_path(model_name: 'field_test', f: {date_field: {'1' => {v: [nil, '', ''], o: 'between'}}})
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
        visit index_path(model_name: 'field_test', f: {date_field: {'1' => {v: [nil, '2021-01-03T00:00:00', nil], o: 'between'}}})
        is_expected.to have_content '1 field test'
        is_expected.to have_content field_tests[1].id
      end
    end
  end

  context 'on create' do
    it 'persists the value' do
      visit new_path(model_name: 'field_test')
      find('[name="field_test[date_field]"]', visible: false).set('2021-01-02T00:00:00')
      click_button 'Save'
      expect(FieldTest.count).to eq 1
      expect(FieldTest.first.date_field).to eq Date.new(2021, 1, 2)
    end
  end

  context 'on update' do
    let(:field_test) { FactoryBot.create :field_test, date_field: Date.new(2021, 1, 2) }

    it 'updates the value' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2021-01-02T00:00:00'
      find('[name="field_test[date_field]"]', visible: false).set('2021-02-03T00:00:00')
      click_button 'Save'
      field_test.reload
      expect(field_test.date_field).to eq Date.new(2021, 2, 3)
    end
  end

  context 'with server timezone changed' do
    let(:field_test) { FactoryBot.create :field_test, date_field: Date.new(2015, 10, 8) }

    around do |example|
      original = Time.zone
      Time.zone = ActiveSupport::TimeZone.new('Central Time (US & Canada)')
      example.run
      Time.zone = original
    end

    it 'is not altered by just saving untouched' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      expect(find('[name="field_test[date_field]"]', visible: false).value).to eq '2015-10-08T00:00:00'
      click_button 'Save'
      expect { field_test.reload }.not_to change(field_test, :date_field)
    end
  end
end
