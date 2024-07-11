

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Configurable do
  class ConfigurableTest
    include RailsAdmin::Config::Configurable

    register_instance_option :foo do
      'default'
    end
  end

  subject { ConfigurableTest.new }

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
