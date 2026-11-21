# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types do
  class MaintainedTestField < RailsAdmin::Config::Fields::Base
    RailsAdmin::Config::Fields::Types.register(self)
  end

  class AbandonedTestField < RailsAdmin::Config::Fields::Base
    RailsAdmin::Config::Fields::Types.register_deprecated(self, reason: 'nothing maintains the editor it loads')
    RailsAdmin::Config::Fields::Types.register_deprecated(:renamed_test_field, self, replacement: :abandoned_test_field)
  end

  describe '.load' do
    it 'returns the class registered under the name derived from it' do
      expect(described_class.load(:maintained_test_field)).to eq MaintainedTestField
    end

    it 'raises for a type nothing registered' do
      expect { described_class.load(:no_such_field) }.to raise_error(/Unsupported field datatype: no_such_field/)
    end

    it 'does not warn for a type registered as maintained' do
      expect(RailsAdmin.deprecator).not_to receive(:warn)
      described_class.load(:maintained_test_field)
    end
  end

  describe '.register_deprecated' do
    before { allow(RailsAdmin.deprecator).to receive(:warn) }

    it 'registers the class like .register does' do
      expect(described_class.load(:abandoned_test_field)).to eq AbandonedTestField
    end

    it 'warns with the reason when the type is loaded' do
      expect(RailsAdmin.deprecator).to receive(:warn).with(/abandoned_test_field field type is deprecated, because nothing maintains the editor it loads/)
      described_class.load(:abandoned_test_field)
    end

    it 'warns naming the replacement when one is given' do
      expect(RailsAdmin.deprecator).to receive(:warn).with(/renamed_test_field field type is deprecated, please use :abandoned_test_field instead/)
      described_class.load(:renamed_test_field)
    end

    it 'resolves a renamed type to the same class as its replacement' do
      expect(described_class.load(:renamed_test_field)).to eq described_class.load(:abandoned_test_field)
    end

    it 'raises when given neither a replacement nor a reason' do
      expect { described_class.register_deprecated(:bad_test_field, MaintainedTestField) }.
        to raise_error(ArgumentError, /either a replacement: or a reason:/)
    end

    it 'raises when given both' do
      expect { described_class.register_deprecated(:bad_test_field, MaintainedTestField, replacement: :x, reason: 'y') }.
        to raise_error(ArgumentError, /either a replacement: or a reason:/)
    end
  end
end
