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

    it "executes only when woken there is a read operation" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('parameter')
      lazy_model.store(block)
      lazy_model.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
    end

    it "raise an error when attempting to double store a configuration" do
      lazy_model.store(block)
      expect { lazy_model.store(other_block) }.to raise_error(RuntimeError, /Please check configurations blocks for Team/)
    end

    it "raise an error when attempting to double store a configuration, even after block was evaluated" do
      lazy_model.store(block)
      lazy_model.groups
      expect { lazy_model.store(other_block) }.to raise_error(RuntimeError, /Please check configurations blocks for Team/)
    end

    it "evaluates config block only once" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).once.with('parameter')
      lazy_model.store(block)
      lazy_model.groups
      lazy_model.groups
    end
  end
end