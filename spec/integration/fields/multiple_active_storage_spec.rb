

require 'spec_helper'

RSpec.describe 'MultipleActiveStorage field', type: :request, active_record: true do
  subject { page }
  before do
    RailsAdmin.config FieldTest do
      edit do
        field :active_storage_assets
      end
    end
    # To suppress 'SQLite3::BusyException: database is locked' exception
    @original = page.driver.browser.url_blacklist # rubocop:disable Naming/InclusiveLanguage
    page.driver.browser.url_blacklist = [%r{/rails/active_storage/representations}] # rubocop:disable Naming/InclusiveLanguage
  end
  after { page.driver.browser.url_blacklist = @original } # rubocop:disable Naming/InclusiveLanguage

  it 'supports uploading multiple files', js: true do
    visit new_path(model_name: 'field_test')
    attach_file 'Active storage assets', [file_path('test.jpg'), file_path('test.png')]
    click_button 'Save'
    is_expected.to have_content 'Field test successfully created'
    expect(FieldTest.first.active_storage_assets.map { |image| image.filename.to_s }).to match_array ['test.jpg', 'test.png']
  end

  context 'when working with existing files' do
    let(:field_test) { FactoryBot.create(:field_test, active_storage_assets: ['test.jpg', 'test.png'].map { |img| {io: File.open(file_path(img)), filename: img} }) }

    it 'supports appending a file', js: true do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      attach_file 'Active storage assets', [file_path('test.gif')]
      click_button 'Save'
      is_expected.to have_content 'Field test successfully updated'
      field_test.reload
      expect(field_test.active_storage_assets.map { |image| image.filename.to_s }).to eq ['test.jpg', 'test.png', 'test.gif']
    end

    it 'supports deleting a file', js: true do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      click_link "Delete 'Active storage assets' #1"
      click_button 'Save'
      is_expected.to have_content 'Field test successfully updated'
      field_test.reload
      expect(field_test.active_storage_assets.map { |image| image.filename.to_s }).to eq ['test.png']
    end
  end

  describe 'direct upload', js: true do
    let(:field_test) { FactoryBot.create :field_test }
    before do
      RailsAdmin.config FieldTest do
        edit do
          configure(:active_storage_assets) { direct true }
        end
      end
    end

    it 'works' do
      visit edit_path(model_name: 'field_test', id: field_test.id)
      attach_file 'Active storage assets', [file_path('test.jpg')]
      expect_any_instance_of(ActiveStorage::DirectUploadsController).to receive(:create).and_call_original
      click_button 'Save'
      expect(page).to have_content 'Field test successfully updated'
      field_test.reload
      expect(field_test.active_storage_assets.map { |image| image.filename.to_s }).to eq ['test.jpg']
    end
  end
end
