require 'spec_helper'

describe RailsAdmin::Config::HasFields do
  it 'shows hidden fields when added through the DSL' do
    expect(RailsAdmin.config(Team).fields.detect { |f| f.name == :division_id }).not_to be_visible

    RailsAdmin.config do |config|
      config.model Team do
        field :division_id
      end
    end

    expect(RailsAdmin.config(Team).fields.detect { |f| f.name == :division_id }).to be_visible
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
    expect { RailsAdmin.config(Team).fields.detect { |f| f.name == :division } }.not_to raise_error
    expect { RailsAdmin.config(Team).fields.detect { |f| f.name == :division }.visible? }.to raise_error("undefined method `[]' for nil:NilClass")
  end

  it 'assigns properties to new one on overriding existing field' do
    RailsAdmin.config do |config|
      config.model Team do
        field :players, :has_and_belongs_to_many_association
      end
    end
    expect(RailsAdmin.config(Team).fields.detect { |f| f.name == :players }.properties).not_to be_nil
  end
end
