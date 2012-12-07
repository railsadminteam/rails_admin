require 'spec_helper'

describe RailsAdmin::Config::LazyModel do
  describe "#store" do
    let(:block) { Proc.new { register_instance_option('parameter') } } # an arbitrary instance method we can spy on
    let(:other_block) { Proc.new { register_instance_option('other parameter') } }

    it "doesn't evaluate the block immediately" do
      RailsAdmin::Config::Model.any_instance.should_not_receive(:register_instance_option)

      RailsAdmin::Config::LazyModel.new(:Team, &block)
    end

    it "evaluates block when reading" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('parameter')

      lazy_model = RailsAdmin::Config::LazyModel.new(:Team, &block)
      lazy_model.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
    end

    it "evaluates config block only once" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).once.with('parameter')

      lazy_model = RailsAdmin::Config::LazyModel.new(:Team, &block)
      lazy_model.groups
      lazy_model.groups
    end
  end
end