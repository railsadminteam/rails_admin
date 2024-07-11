

require 'spec_helper'

RSpec.describe 'ActiveStorage field', type: :request, active_record: true do
  subject { page }
  let(:field_test) { FactoryBot.create :field_test }
  before do
    # To suppress 'SQLite3::BusyException: database is locked' exception
    @original = page.driver.browser.url_blacklist # rubocop:disable Naming/InclusiveLanguage
    page.driver.browser.url_blacklist = [%r{/rails/active_storage/representations}] # rubocop:disable Naming/InclusiveLanguage
  end
  after { page.driver.browser.url_blacklist = @original } # rubocop:disable Naming/InclusiveLanguage

  describe 'direct upload', js: true do
    before do
      RailsAdmin.config FieldTest do
        edit do
          field(:active_storage_asset) { direct true }
        end
      end
    end

    it 'works' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      attach_file 'Active storage asset', file_path('test.jpg')
      expect_any_instance_of(ActiveStorage::DirectUploadsController).to receive(:create).and_call_original
      click_button 'Save'
      expect(page).to have_content 'Field test successfully updated'
      field_test.reload
      expect(field_test.active_storage_asset.filename).to eq 'test.jpg'
    end
  end
end
