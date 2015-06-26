require 'spec_helper'

describe RailsAdmin::Config::Fields::Association do
  describe '#pretty_value' do
    let(:player) { FactoryGirl.create(:player, name: '<br />', team: FactoryGirl.create(:team)) }
    let(:field) { RailsAdmin.config('Team').fields.detect { |f| f.name == :players } }
    let(:view) { ActionView::Base.new.tap { |d| allow(d).to receive(:action).and_return(nil) } }
    subject { field.with(object: player.team, view: view).pretty_value }

    context 'when the link is disabled' do
      it 'does not expose non-HTML-escaped string' do
        is_expected.to be_html_safe
        is_expected.to eq '&lt;br /&gt;'
      end
    end
  end
end
