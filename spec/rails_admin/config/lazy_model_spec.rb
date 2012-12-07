require 'spec_helper'

describe RailsAdmin::Config::LazyModel do
  let(:lazy_model) { RailsAdmin::Config::LazyModel.new(:Team) }

  describe "#store" do
    let(:block) { Proc.new { register_instance_option('parameter') } } # an arbitrary instance method we can spy on
    let(:other_block) { Proc.new { register_instance_option('other parameter') } }

    it "doesn't execute the block immediately" do
      RailsAdmin::Config::Model.any_instance.should_not_receive(:register_instance_option)
      lazy_model.store(block)
    end

    it "executes only when reading" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('parameter')
      lazy_model.store(block)
      lazy_model.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
    end

    it "evaluates only last block" do
      RailsAdmin::Config::Model.any_instance.should_not_receive(:register_instance_option).with('parameter')
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('other parameter')
      lazy_model.store(block)
      lazy_model.store(other_block)
      lazy_model.groups
    end

    it "resets models when a new block is given" do
      lazy_model.store(block)
      lazy_model.groups
      RailsAdmin::Config::Model.should_receive(:new)
      lazy_model.store(other_block)
    end

    it "evaluates config block only once" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).once.with('parameter')
      lazy_model.store(block)
      lazy_model.groups
      lazy_model.groups
    end
  end
end