require 'spec_helper'

describe "RailsAdmin::FormBuilder" do
  describe "#generate" do
    before do
      helper.stub(:authorized?).and_return(true)
      (@object = Player.new).save
      @builder = RailsAdmin::FormBuilder.new(:player, @object, helper, {}, nil)
      @builder.stub(:field_for).and_return("field")
    end

    it "does not add additional error div from default ActionView::Base.field_error_proc" do
      expect(@builder.generate({ :action => :create, :model_config => RailsAdmin.config(Player) })).not_to have_css(".field_with_errors")
      expect(@builder.generate({ :action => :create, :model_config => RailsAdmin.config(Player) })).to have_css(".control-group.error")
    end
  end
end
