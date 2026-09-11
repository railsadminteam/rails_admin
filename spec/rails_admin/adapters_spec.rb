# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Adapters do
  around do |example|
    registered = described_class.registrations.dup
    example.run
    described_class.registrations.replace(registered)
  end

  let(:reflection_class) { Class.new(RailsAdmin::Adapters::Reflection) }
  let(:repository_class) { Class.new(RailsAdmin::Adapters::Repository) }
  let(:model) { Class.new }

  def register(name, **options, &detector)
    described_class.register(name, reflection: reflection_class, repository: repository_class, **options, &detector)
  end

  describe '.detect' do
    it 'returns the registration whose detector matches' do
      register(:fake) { |candidate| candidate == model }

      registration = described_class.detect(model)
      expect(registration.name).to eq :fake
      expect(registration.reflection).to eq reflection_class
      expect(registration.repository).to eq repository_class
    end

    it 'returns nil when no adapter claims the model' do
      expect(described_class.detect(model)).to be_nil
    end

    it 'asks the most recently registered adapter first' do
      register(:first) { true }
      register(:second) { true }

      expect(described_class.detect(model).name).to eq :second
    end
  end

  # An application using one ORM must not have the other one required on its
  # behalf, so nothing about an adapter may be loaded until a model matches it.
  describe 'loading' do
    it 'leaves a named class alone until its adapter matches a model' do
      register(:unloadable,
               require_path: 'rails_admin/adapters/no_such_adapter',
               reflection: 'NoSuchAdapter::Reflection',
               repository: 'NoSuchAdapter::Repository') { |candidate| candidate == model }

      expect { described_class.detect(Class.new) }.not_to raise_error
      expect { described_class.detect(model).reflection }.to raise_error LoadError
    end

    it 'resolves a named class on first use' do
      register(:named, reflection: 'RailsAdmin::Adapters::Reflection') { true }

      expect(described_class.detect(model).reflection).to eq RailsAdmin::Adapters::Reflection
    end
  end

  it 'gives no AbstractModel to a model no adapter claims' do
    stub_const('Unclaimed', model)

    expect(RailsAdmin::AbstractModel.new('Unclaimed')).to be_nil
  end
end
