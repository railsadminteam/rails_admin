require 'spec_helper'

RSpec.describe 'Datetimepicker widget', type: :request, js: true do
  before do
    RailsAdmin.config FieldTest do
      edit do
        field :datetime_field
      end
    end
  end

  it 'is initially blank' do
    visit new_path(model_name: 'field_test')
    expect(find('[name="field_test[datetime_field]"]', visible: false).value).to be_blank
    expect(find('#field_test_datetime_field').value).to be_blank
  end

  it 'populates the value selected by the Datetime picker into the hidden_field' do
    visit new_path(model_name: 'field_test')
    page.execute_script <<-JS
      $('#field_test_datetime_field').data("DateTimePicker").date(moment('2015-10-08 14:00:00')).toggle();
    JS
    expect(find('#field_test_datetime_field').value).to eq 'October 08, 2015 14:00'
    expect(find('[name="field_test[datetime_field]"]', visible: false).value).to eq '2015-10-08T14:00:00'
  end

  it 'populates the value entered in the text field into the hidden_field' do
    visit new_path(model_name: 'field_test')
    fill_in 'Datetime field', with: 'January 2, 2021 03:45'
    expect(find('[name="field_test[datetime_field]"]', visible: false).value).to eq '2021-01-02T03:45:00'
    expect(find('#field_test_datetime_field').value).to eq 'January 02, 2021 03:45'
  end

  it 'works with a different format' do
    RailsAdmin.config FieldTest do
      edit do
        configure(:datetime_field) { strftime_format '%Y-%m-%d' }
      end
    end
    visit new_path(model_name: 'field_test')
    fill_in 'Datetime field', with: '2021-01-02'
    expect(find('[name="field_test[datetime_field]"]', visible: false).value).to eq '2021-01-02T00:00:00'
    expect(find('#field_test_datetime_field').value).to eq '2021-01-02'
  end

  it 'supports custom momentjs_format' do
    RailsAdmin.config FieldTest do
      edit do
        configure(:datetime_field) { momentjs_format 'HH[H]mm[M]ss[S]' }
      end
    end
    visit new_path(model_name: 'field_test')
    page.execute_script <<-JS
      $('#field_test_datetime_field').data("DateTimePicker").date(moment('2015-10-08 12:34:56')).toggle();
    JS
    expect(find('#field_test_datetime_field').value).to eq '12H34M56S'
  end

  context 'with locale set' do
    around(:each) do |example|
      original = I18n.default_locale
      I18n.default_locale = :fr
      example.run
      I18n.default_locale = original
    end

    it 'shows and accepts the value in the given locale' do
      visit new_path(model_name: 'field_test', field_test: {datetime_field: '2021-01-02T03:45:00'})
      expect(find('[name="field_test[datetime_field]"]', visible: false).value).to eq '2021-01-02T03:45:00'
      expect(find('#field_test_datetime_field').value).to eq "samedi 02 janvier 2021 03:45"
      fill_in 'Datetime field', with: 'mercredi 03 février 2021 04:55'
      expect(find('[name="field_test[datetime_field]"]', visible: false).value).to eq '2021-02-03T04:55:00'
    end
  end
end
