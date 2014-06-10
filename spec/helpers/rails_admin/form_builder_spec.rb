require 'spec_helper'

describe 'RailsAdmin::FormBuilder', type: :helper do
  describe '#generate' do
    before do
      allow(helper).to receive(:authorized?).and_return(true)
      (@object = Player.new).save
      @builder = RailsAdmin::FormBuilder.new(:player, @object, helper, {})
      allow(@builder).to receive(:field_for).and_return('field')
    end

    it 'does not add additional error div from default ActionView::Base.field_error_proc' do
      expect(@builder.generate(action: :create, model_config: RailsAdmin.config(Player))).not_to have_css('.field_with_errors')
      expect(@builder.generate(action: :create, model_config: RailsAdmin.config(Player))).to have_css('.control-group.error')
    end
  end

  describe '#object_infos' do
    before do
      allow(helper).to receive(:authorized?).and_return(true)
      @object = Fan.create!(name: 'foo')
      @builder = RailsAdmin::FormBuilder.new(:fan, @object, helper, {})
    end

    it 'returns a tag with infos' do
      expect(@builder.object_infos).to eql '<span style="display:none" class="object-infos" data-model-label="Fan" data-object-label="foo"></span>'
    end

    context 'when object_label\'s type is symbol' do
      before { @object.name = :foo }

      it 'does not break' do
        expect(@builder.object_infos).to eql '<span style="display:none" class="object-infos" data-model-label="Fan" data-object-label="foo"></span>'
      end
    end
  end
end
