

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Dragonfly do
  it_behaves_like 'a generic field type', :string_field, :dragonfly

  describe 'with a model which does not extend Dragonfly::Model' do
    before do
      class NonDragonflyTest < Tableless
        column :asset_uid, :varchar
      end
    end

    it 'does not break' do
      expect { RailsAdmin.config(NonDragonflyTest).fields }.not_to raise_error
    end
  end
end
