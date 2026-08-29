# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Support::AssetSource do
  describe '.resolve' do
    it 'passes through the supported values' do
      %i[propshaft sprockets external].each do |source|
        expect(described_class.resolve(source)).to eq source
      end
    end

    it 'passes through a callable' do
      callable = ->(view) { view }
      expect(described_class.resolve(callable)).to eq callable
    end

    it 'auto-detects the pipeline when given nil' do
      expect(described_class.resolve(nil)).to be_in(%i[propshaft sprockets])
    end

    it 'maps the deprecated :webpack to :external with a warning' do
      expect(described_class).to receive(:warn).with(/:webpack is deprecated/)
      expect(described_class.resolve(:webpack)).to eq :external
    end

    it 'maps the deprecated :importmap to the detected pipeline with a warning' do
      expect(described_class).to receive(:warn).with(/:importmap is deprecated/)
      expect(described_class.resolve(:importmap)).to be_in(%i[propshaft sprockets])
    end

    it 'raises for the removed :webpacker and :vite' do
      %i[webpacker vite].each do |source|
        expect { described_class.resolve(source) }.to raise_error(/no longer supported/)
      end
    end

    it 'raises for an unknown value' do
      expect { described_class.resolve(:nope) }.to raise_error(/Unknown config.asset_source/)
    end
  end

  describe '.detect' do
    it 'prefers Propshaft, then Sprockets, then Propshaft' do
      expect(described_class.detect).to be_in(%i[propshaft sprockets])
    end
  end
end
