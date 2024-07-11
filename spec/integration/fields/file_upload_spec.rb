

require 'spec_helper'

RSpec.describe 'FileUpload field', type: :request do
  subject { page }

  before do
    RailsAdmin.config FieldTest do
      field :string_field, :file_upload do
        delete_method 'boolean_field'
        def resource_url(_thumb = false)
          value
        end
      end
    end
  end
  let(:field_test) { FactoryBot.create :field_test, string_field: 'http://localhost/dummy.jpg' }

  it 'supports deletion', js: true do
    visit edit_path(model_name: 'field_test', id: field_test.id)
    expect(find('#field_test_boolean_field', visible: false)).not_to be_checked
    click_link "Delete 'String field'"
    expect(find('#field_test_boolean_field', visible: false)).to be_checked
  end

  it 'shows a inline preview', js: true do
    visit new_path(model_name: 'field_test')
    attach_file 'String field', file_path('test.jpg')
    is_expected.to have_selector('#field_test_string_field_field img.preview')
  end
end
