

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Sections::List do
  describe '#fields_for_table' do
    subject { RailsAdmin.config(Player).list }

    it 'brings sticky fields first' do
      RailsAdmin.config Player do
        list do
          field(:number)
          field(:id)
          field(:name) { sticky true }
        end
      end
      expect(subject.fields_for_table.map(&:name)).to eq %i[name number id]
    end

    it 'keep the original order except for stickey ones' do
      RailsAdmin.config Player do
        list do
          configure(:number) { sticky true }
        end
      end
      expect(subject.fields_for_table.map(&:name)).to eq %i[number] + (subject.visible_fields.map(&:name) - %i[number])
    end
  end
end
