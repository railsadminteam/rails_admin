

require 'spec_helper'

RSpec.describe RailsAdmin::Engine do
  context 'on class unload' do
    let(:fields) { RailsAdmin.config(Player).edit.fields }
    before do
      Rails.application.config.cache_classes = false
      RailsAdmin.config(Player) do
        field :name
        field :number
      end
    end
    after { Rails.application.config.cache_classes = true }

    it 'triggers RailsAdmin config to be reloaded' do
      # this simulates rails code reloading
      RailsAdmin::Engine.initializers.find do |i|
        i.name == 'RailsAdmin reload config in development'
      end.block.call(Rails.application)
      Rails.application.executor.wrap do
        ActiveSupport::Reloader.new.tap(&:class_unload!).complete!
      end

      RailsAdmin.config(Player) do
        field :number
      end
      expect(fields.map(&:name)).to match_array %i[number]
    end
  end
end
