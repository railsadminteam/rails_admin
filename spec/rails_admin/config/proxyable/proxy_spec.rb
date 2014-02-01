require 'spec_helper'

describe RailsAdmin::Config::Proxyable::Proxy do
  class ProxyTest
    def initialize
      @bindings = {:foo => 'bar'}
    end

    def get_bindings
      @bindings
    end
  end

  let(:proxy_test){ ProxyTest.new }
  subject{ RailsAdmin::Config::Proxyable::Proxy.new proxy_test, :foo => 'baz' }

  it 'proxies method calls to @object' do
    expect(subject.get_bindings).to eq :foo => 'baz'
  end

  it 'preserves initially set @bindings' do
    subject.get_bindings
    expect(proxy_test.get_bindings).to eq :foo => 'bar'
  end
end
