

require 'fileutils'
require 'spec_helper'

RSpec.describe 'RailsAdmin::Version' do
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
      expect(RailsAdmin::Version).to receive(:warn).with(/yarn install/)
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
    unless CI_ASSET == :sprockets
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
