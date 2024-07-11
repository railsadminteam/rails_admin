

require 'spec_helper'

RSpec.describe RailsAdmin::Config::LazyModel do
  subject { RailsAdmin::Config::LazyModel.new(:Team, &block) }
  let(:block) { proc { register_instance_option('parameter') } } # an arbitrary instance method we can spy on

  describe '#initialize' do
    it "doesn't evaluate the block immediately" do
      expect_any_instance_of(RailsAdmin::Config::Model).not_to receive(:register_instance_option)
      subject
    end

    it 'evaluates block when reading' do
      expect_any_instance_of(RailsAdmin::Config::Model).to receive(:register_instance_option).with('parameter')
      subject.groups # an arbitrary instance method on RailsAdmin::Config::Model to wake up lazy_model
    end

    it 'evaluates config block only once' do
      expect_any_instance_of(RailsAdmin::Config::Model).to receive(:register_instance_option).once.with('parameter')

      subject.groups
      subject.groups
    end
  end

  describe '#add_deferred_block' do
    let(:another_block) { proc { register_instance_option('parameter2') } }

    it "doesn't evaluate the block immediately" do
      expect_any_instance_of(RailsAdmin::Config::Model).not_to receive(:register_instance_option).with('parameter2')
      subject.add_deferred_block(&another_block)
    end

    it 'evaluates the block immediately after initialization' do
      subject.target
      expect_any_instance_of(RailsAdmin::Config::Model).to receive(:register_instance_option).with('parameter2')
      subject.add_deferred_block(&another_block)
    end
  end

  context 'when a method is defined in Kernel' do
    before do
      Kernel.module_eval do
        def weight
          42
        end
      end
    end

    after do
      Kernel.module_eval do
        undef weight
      end
    end

    it 'proxies calls for the method to @object' do
      expect(subject.weight).to eq 0
    end
  end
end
