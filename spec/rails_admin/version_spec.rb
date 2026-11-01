# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'

RSpec.describe 'RailsAdmin::Version' do
  describe '#npm_dependency' do
    # A range is not a URL, so the editors RailsAdmin builds CDN URLs from have to be pinned exactly.
    %w[codemirror easymde trix].each do |package|
      it "returns the exact version #{package} is pinned to" do
        expect(RailsAdmin::Version.npm_dependency(package)).to match(/\A\d+\.\d+\.\d+\z/)
      end
    end

    it 'raises when the package is not pinned' do
      expect { RailsAdmin::Version.npm_dependency('not-a-package') }.to raise_error(KeyError)
    end
  end

  describe '#warn_with_js_version' do
    it 'does nothing when the versions match' do
      allow(RailsAdmin::Version).to receive(:actual_js_version).and_return('3.0.0')
      allow(RailsAdmin::Version).to receive(:js).and_return('3.0.0')
      expect(RailsAdmin::Version).not_to receive(:warn)
      RailsAdmin::Version.warn_with_js_version
    end

    it "shows a warning when actual_js_version couldn't detected" do
      allow(RailsAdmin::Version).to receive(:actual_js_version).and_return(nil)
      allow(RailsAdmin::Version).to receive(:js).and_return('3.0.1')
      expect(RailsAdmin::Version).to receive(:warn).with(/Failed to detect the RailsAdmin npm package/)
      RailsAdmin::Version.warn_with_js_version
    end

    it 'shows a warning when the versions do not match' do
      allow(RailsAdmin::Version).to receive(:actual_js_version).and_return('3.0.0')
      allow(RailsAdmin::Version).to receive(:js).and_return('3.0.1')
      expect(RailsAdmin::Version).to receive(:warn).with(/inconsistency/)
      RailsAdmin::Version.warn_with_js_version
    end
  end

  describe '#js_version_from_node_modules' do
    if CI_ASSET == :external
      let(:path) { Rails.root.join('node_modules/rails_admin/package.json') }
      before do
        @backup = File.read(path)
        FileUtils.rm(path)
      end
      after { File.write(path, @backup) }

      it 'returns nil when RailsAdmin package.json is not found' do
        expect(RailsAdmin::Version.send(:js_version_from_node_modules)).to be_nil
      end

      it 'shows a warning when RailsAdmin package.json is not found' do
        File.write(path, '{"version": "0.1.0-alpha"}')
        expect(RailsAdmin::Version.send(:js_version_from_node_modules)).to eq '0.1.0-alpha'
      end
    end
  end
end
