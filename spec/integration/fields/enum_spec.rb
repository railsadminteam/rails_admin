

require 'spec_helper'

RSpec.describe 'Enum field', type: :request, active_record: true do
  subject { page }

  before do
    allow_any_instance_of(Team).to receive(:color_enum).and_return(%w[blue green red])
  end

  describe 'for single value' do
    before do
      RailsAdmin.config Team do
        field :color
      end
    end

    it 'shows a single-value edit form' do
      visit new_path(model_name: 'team')
      is_expected.to have_selector('.enum_type select')
      is_expected.not_to have_selector('.enum_type select[multiple]')
      expect(all('.enum_type option').map(&:text).select(&:present?)).to eq %w[blue green red]
    end

    it 'uses the filtering-select widget for selection', js: true do
      visit new_path(model_name: 'team')
      is_expected.to have_selector('.enum_type .filtering-select')
    end
  end

  describe 'for multiple values' do
    before do
      RailsAdmin.config Team do
        field :color do
          multiple true
        end
      end
    end

    it 'shows a multiple-value edit form' do
      visit new_path(model_name: 'team')
      is_expected.to have_selector('.enum_type select')
      is_expected.to have_selector('.enum_type select[multiple]')
      expect(all('.enum_type option').map(&:text).select(&:present?)).to eq %w[blue green red]
    end

    it 'uses the filtering-multiselect widget for selection', js: true do
      visit new_path(model_name: 'team')
      is_expected.to have_selector('.enum_type .ra-multiselect')
    end
  end
end
