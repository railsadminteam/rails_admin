

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

  it 'supports limiting filter operators' do
    RailsAdmin.config Player do
      list do
        field :name do
          filter_operators %w[is starts_with _present]
        end
      end
    end

    visit index_path(model_name: 'player')
    is_expected.to have_no_css('#filters_box .filter')
    click_link 'Add filter'
    click_link 'Name'

    within(:select, name: /f\[name\]\[\d+\]\[o\]/) do
      expect(page.all('option').map(&:value)).to eq %w[is starts_with _present]
    end
  end

  it 'does not cause duplication when using browser back' do
    RailsAdmin.config Player do
      field :name
    end

    visit index_path(model_name: 'player', f: {name: {'1' => {v: 'a'}}})
    find(%([href$="/admin/player/export"])).click
    is_expected.to have_content 'Export Players'
    page.go_back
    is_expected.to have_content 'List of Players'
    expect(all(:css, '#filters_box div.filter').count).to eq 1
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
        field :color, :enum
      end
    end

    it 'supports multiple selection mode' do
      visit index_path(model_name: 'team')
      click_link 'Add filter'
      click_link 'Color'
      expect(all('#filters_box option').map(&:text)).to include 'white', 'black', 'red', 'green', 'blu<e>é'
      find('.filter .switch-select .fa-plus').click
      expect(find('#filters_box select')['multiple']).to be true
      expect(find('#filters_box select')['name']).to match(/\[\]$/)
    end

    context 'with the filter pre-populated' do
      it 'does not break' do
        visit index_path(model_name: 'team', f: {color: {'1' => {v: 'red'}}})
        is_expected.to have_css('.filter select[name^="f[color]"]')
        expect(find('.filter select[name^="f[color]"]').value).to eq 'red'
        expect(all('#filters_box option').map(&:text)).to include 'white', 'black', 'red', 'green', 'blu<e>é'
      end
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

  describe 'for has_one association field' do
    before do
      RailsAdmin.config Player do
        field :draft do
          searchable :college
        end
      end
    end

    it 'is filterable' do
      visit index_path(model_name: 'player')
      click_link 'Add filter'
      click_link 'Draft'
      expect(page).to have_css '[name^="f[draft]"][name$="[o]"]'
      expect(page).to have_css '[name^="f[draft]"][name$="[v]"]'
    end
  end
end
