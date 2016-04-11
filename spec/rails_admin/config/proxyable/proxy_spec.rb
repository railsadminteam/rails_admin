require 'spec_helper'

describe RailsAdmin::Config::Proxyable::Proxy do
  class ProxyTest
    attr_reader :bindings
    def initialize
      @bindings = {foo: 'bar'}
    end

    def qux
      'foobar'
    end
  end

  let(:proxy_test) { ProxyTest.new }
  subject { RailsAdmin::Config::Proxyable::Proxy.new proxy_test, foo: 'baz' }

  it 'proxies method calls to @object' do
    expect(subject.bindings).to eq foo: 'baz'
  end

  it 'preserves initially set @bindings' do
    subject.bindings
    expect(proxy_test.bindings).to eq foo: 'bar'
  end

  context 'when a method is defined in Kernel' do
    before do
      Kernel.module_eval do
        def qux
          'quux'
        end
      end
    end

    after do
      Kernel.module_eval do
        undef qux
      end
    end

    it 'proxies calls for the method to @object' do
      expect(subject.qux).to eq 'foobar'
    end
  end
end
