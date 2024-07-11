

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Paperclip do
  it_behaves_like 'a generic field type', :string_field, :paperclip

  context 'when a *_file_name field exists but not declared as has_attached_file' do
    before do
      class PaperclipTest < Tableless
        column :some_file_name, :varchar
      end
      RailsAdmin.config.included_models = [PaperclipTest]
    end

    it 'does not break' do
      expect { RailsAdmin.config(PaperclipTest).fields }.not_to raise_error
    end
  end
end
