require 'spec_helper'

RSpec.describe 'Filter box widget', type: :request, js: true do
  subject { page }

  it 'adds filters' do
    RailsAdmin.config Player do
      field :name
      field :position
    end
    visit index_path(model_name: 'player')
    is_expected.to have_no_css('#filters_box .filter')
    click_link 'Add filter'
    click_link 'Name'
    within('#filters_box') do
      is_expected.to have_css('.filter', count: 1)
      is_expected.to have_css('.filter select[name^="f[name]"]')
    end
    click_link 'Add filter'
    click_link 'Position'
    within('#filters_box') do
      is_expected.to have_css('.filter', count: 2)
      is_expected.to have_css('.filter select[name^="f[position]"]')
    end
  end

  it 'removes filters' do
    RailsAdmin.config Player do
      field :name
      field :position
    end
    visit index_path(model_name: 'player')
    is_expected.to have_no_css('#filters_box .filter')
    click_link 'Add filter'
    click_link 'Name'
    click_link 'Add filter'
    click_link 'Position'
    within('#filters_box') do
      is_expected.to have_css('.filter', count: 2)
      click_button 'Name'
      is_expected.to have_no_css('.filter select[name^="f[name]"]')
      click_button 'Position'
      is_expected.to have_no_css('.filter')
    end
  end

  it 'hides redundant filter options for required fields' do
    RailsAdmin.config Player do
      list do
        field :name do
          required true
        end
        field :team
      end
    end

    visit index_path(model_name: 'player', f: {name: {'1' => {v: ''}}, team: {'2' => {v: ''}}})

    within(:select, name: 'f[name][1][o]') do
      expect(page.all('option').map(&:value)).to_not include('_present', '_blank')
    end

    within(:select, name: 'f[team][2][o]') do
      expect(page.all('option').map(&:value)).to include('_present', '_blank')
    end
  end

  describe 'for boolean field' do
    before do
      RailsAdmin.config FieldTest do
        field :boolean_field
      end
    end

    it 'is filterable with true and false' do
      visit index_path(model_name: 'field_test')
      click_link 'Add filter'
      click_link 'Boolean field'
      within('#filters_box') do
        expect(page.all('option').map(&:value)).to include('true', 'false')
      end
    end
  end

  describe 'for date field' do
    before do
      RailsAdmin.config FieldTest do
        field :date_field
      end
    end

    it 'populates the value selected by the Datetimepicker into the hidden_field' do
      visit index_path(model_name: 'field_test')
      click_link 'Add filter'
      click_link 'Date field'
      expect(find('[name^="f[date_field]"][name$="[v][]"]', match: :first, visible: false).value).to be_blank
      page.execute_script <<-JS
        document.querySelector('.form-control.date')._flatpickr.setDate('2015-10-08');
      JS
      expect(find('[name^="f[date_field]"][name$="[v][]"]', match: :first, visible: false).value).to eq '2015-10-08T00:00:00'
    end
  end

  describe 'for datetime field' do
    before do
      RailsAdmin.config FieldTest do
        field :datetime_field
      end
    end

    it 'populates the value selected by the Datetimepicker into the hidden_field' do
      visit index_path(model_name: 'field_test')
      click_link 'Add filter'
      click_link 'Datetime field'
      expect(find('[name^="f[datetime_field]"][name$="[v][]"]', match: :first, visible: false).value).to be_blank
      page.execute_script <<-JS
        document.querySelector('.form-control.datetime')._flatpickr.setDate('2015-10-08 14:00:00');
      JS
      expect(find('[name^="f[datetime_field]"][name$="[v][]"]', match: :first, visible: false).value).to eq '2015-10-08T14:00:00'
    end
  end

  describe 'for enum field' do
    before do
      RailsAdmin.config Team do
        field :color
      end
    end

    it 'supports multiple selection mode' do
      visit index_path(model_name: 'team')
      click_link 'Add filter'
      click_link 'Color'
      expect(all('.select-single option').map(&:text)).to include 'white', 'black', 'red', 'green', 'blu<e>é'
      find('.filter .switch-select .fa-plus').click
      expect(all('.select-multiple option').map(&:text)).to include 'white', 'black', 'red', 'green', 'blu<e>é'
    end
  end

  describe 'for time field', active_record: true do
    before do
      RailsAdmin.config FieldTest do
        field :time_field
      end
    end

    it 'populates the value selected by the Datetimepicker into the hidden_field' do
      visit index_path(model_name: 'field_test')
      click_link 'Add filter'
      click_link 'Time field'
      expect(find('[name^="f[time_field]"][name$="[v][]"]', match: :first, visible: false).value).to be_blank
      page.execute_script <<-JS
        document.querySelector('.form-control.datetime')._flatpickr.setDate('2000-01-01 14:00:00');
      JS
      expect(find('[name^="f[time_field]"][name$="[v][]"]', match: :first, visible: false).value).to eq '2000-01-01T14:00:00'
    end
  end
end
