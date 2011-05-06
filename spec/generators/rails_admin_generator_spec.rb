require 'spec_helper'

describe 'RailsAdmin::RailsAdminGenerator' do
  context "with no arguments" do
    include GeneratorSpec::TestCase

    destination File.expand_path("../tmp", __FILE__)
    tests RailsAdmin::RailsAdminGenerator

    before do
      prepare_destination
      run_generator
    end

    it "should not raise any exceptions" do; end

  end
end
