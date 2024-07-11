

require 'spec_helper'

RSpec.describe 'MultipleFileUpload field', type: :request do
  subject { page }

  before do
    RailsAdmin.config FieldTest do
      field :string_field, :multiple_file_upload do
        attachment do
          delete_value { value }
          def resource_url(_thumb = false)
            value
          end
        end
        delete_method 'boolean_field'
        reorderable true
        def value
          bindings[:object].safe_send(name)&.split
        end
      end
    end
  end
  let(:field_test) { FactoryBot.create :field_test, string_field: 'http://localhost/1.jpg http://localhost/2.jpg' }

  it 'supports deletion', js: true do
    visit edit_path(model_name: 'field_test', id: field_test.id)
    click_link "Delete 'String field' #1"
    expect(page.all(:css, '[name="field_test[boolean_field][]"]:checked', visible: false).map(&:value)).to eq %w[http://localhost/1.jpg]
  end

  it 'shows a inline preview', js: true do
    visit new_path(model_name: 'field_test')
    attach_file 'String field', file_path('test.jpg')
    is_expected.to have_selector('#field_test_string_field_field img.preview')
  end
end
