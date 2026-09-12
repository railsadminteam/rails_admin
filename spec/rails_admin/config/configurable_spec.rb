# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Configurable do
  class ConfigurableTest
    include RailsAdmin::Config::Configurable

    register_instance_option :foo do
      'default'
    end
  end

  class ConfigurableWithDeprecationTest
    include RailsAdmin::Config::Configurable

    register_instance_option :bar do
      'default'
    end

    register_deprecated_instance_option :old_bar, :bar

    register_deprecated_instance_option(:old_qux) { 'custom result' }

    register_deprecated_instance_option :unsupported_baz
  end

  subject { ConfigurableTest.new }

  describe '#register_deprecated_instance_option' do
    subject { ConfigurableWithDeprecationTest.new }

    it 'warns through RailsAdmin.deprecator and forwards to the replacement' do
      expect(RailsAdmin.deprecator).to receive(:warn).with(/old_bar.*bar/)
      expect(subject.old_bar).to eq('default')
    end

    it 'runs a custom handler when declared with a block instead of a replacement' do
      expect(subject.old_qux).to eq('custom result')
    end

    it 'raises when declared with neither' do
      expect { subject.unsupported_baz }.to raise_error(/unsupported_baz configuration option is removed/)
    end
  end

  describe 'recursion tracking' do
    it 'works and use default value' do
      subject.instance_eval do
        foo { foo }
      end
      expect(subject.foo).to eq 'default'
    end

    describe 'with parallel execution' do
      before do
        subject.instance_eval do
          foo do
            sleep 0.15
            'value'
          end
        end
      end

      it 'ensures thread-safety' do
        threads = Array.new(2) do |i|
          Thread.new do
            sleep i * 0.1
            expect(subject.foo).to eq 'value'
          end
        end
        threads.each(&:join)
      end
    end
  end
end
