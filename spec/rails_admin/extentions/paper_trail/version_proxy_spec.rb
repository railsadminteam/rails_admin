

require 'spec_helper'

RSpec.describe RailsAdmin::Extensions::PaperTrail::VersionProxy, active_record: true do
  describe '#username' do
    subject { described_class.new(version, user_class).username }

    let(:version) { double(whodunnit: :the_user) }
    let(:user_class) { double(find: user) }

    context 'when found user has email' do
      let(:user) { double(email: :mail) }
      it { is_expected.to eq(:mail) }
    end

    context 'when found user does not have email' do
      let(:user) { double } # no email method

      it { is_expected.to eq(:the_user) }
    end
  end
end
