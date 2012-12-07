require 'spec_helper'

describe RailsAdmin::Config::LazyModel do
  let(:lazy_model) { RailsAdmin::Config::LazyModel.new(:Team) }

  describe "#run" do
    let(:block) { Proc.new { register_instance_option('parameter') } } # an arbitrary instance method we can spy on
    let(:other_block) { Proc.new { register_instance_option('other parameter') } }

    it "doesn't execute the block immediately" do
      RailsAdmin::Config::Model.any_instance.should_not_receive(:register_instance_option)

      lazy_model.run(block)
      lazy_model.run(other_block)
    end

    it "executes all blocks when woken up" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('parameter').and_return
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('other parameter').and_return

      lazy_model.run(block)
      lazy_model.run(other_block)
      lazy_model.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
    end

    it "once awake, executes further blocks immediately" do
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('parameter').and_return
      RailsAdmin::Config::Model.any_instance.should_receive(:register_instance_option).with('other parameter').and_return

      lazy_model.run(block)
      lazy_model.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
      lazy_model.run(other_block)
    end
  end
end