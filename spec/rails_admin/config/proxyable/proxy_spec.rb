require 'spec_helper'

describe RailsAdmin::Config::Proxyable::Proxy do
  class ProxyTest
    attr_reader :bindings
    def initialize
      @bindings = {foo: 'bar'}
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
end
