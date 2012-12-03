require 'spec_helper'

describe RailsAdmin::CSVConverter do
  it "keeps headers ordering" do
    RailsAdmin.config(Player) do
      export do
        field :number
        field :name
      end
    end

    objects = [FactoryGirl.create(:player)]
    schema = {:only =>[:number, :name]}
    expect(RailsAdmin::CSVConverter.new(objects, schema).to_csv({})[2]).to match /Number,Name/
  end
end
