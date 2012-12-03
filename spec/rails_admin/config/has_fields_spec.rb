require 'spec_helper'

describe RailsAdmin::Config::HasFields do

  it 'shows hidden fields when added through the DSL' do
    expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division_id}).to_not be_visible

    RailsAdmin.config do |config|
      config.model Team do
        field :division_id
      end
    end

    expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division_id}).to be_visible
  end

  it 'does not set visibility for fields with bindings' do
    RailsAdmin.config do |config|
      config.model Team do
        field :division do
          visible do
            bindings[:controller].current_user.email == 'test@email.com'
          end
        end
      end
    end
    expect {RailsAdmin.config(Team).fields.find{|f| f.name == :division }}.to_not raise_error
    expect {RailsAdmin.config(Team).fields.find{|f| f.name == :division }.visible?}.to raise_error "undefined method `[]' for nil:NilClass"
  end
end
