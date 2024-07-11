

require 'spec_helper'

RSpec.describe RailsAdmin::Config::HasDescription do
  it 'shows description message when added through the DSL' do
    RailsAdmin.config do |config|
      config.model Team do
        desc 'Description of Team model'
      end
    end

    expect(RailsAdmin.config(Team).description).to eq('Description of Team model')
  end
end
