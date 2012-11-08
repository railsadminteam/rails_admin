require 'spec_helper'
require File.expand_path('../../../config/initializers/active_record_extensions', __FILE__)

describe "ActiveRecord::Base", :active_record => true do
  describe "#safe_send" do
    it "only calls #read_attribute once" do
      @player = Player.new
      @player.number = 23
      original_method = @player.method(:read_attribute)
      @player.should_receive(:read_attribute).exactly(1).times do |*args|
        original_method.call(*args)
      end
      expect(@player.safe_send(:number)).to eq(23)
    end
  end
end
