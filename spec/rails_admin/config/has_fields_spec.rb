

require 'spec_helper'

RSpec.describe RailsAdmin::Config::HasFields do
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
    expect { RailsAdmin.config(Team).fields.detect { |f| f.name == :division }.visible? }.to raise_error(/undefined method `\[\]' for nil/)
  end

  it 'assigns properties to new one on overriding existing field' do
    RailsAdmin.config do |config|
      config.model Team do
        field :players, :has_and_belongs_to_many_association
      end
    end
    expect(RailsAdmin.config(Team).fields.detect { |f| f.name == :players }.properties).not_to be_nil
  end

  describe '#configure' do
    it 'does not change the order of existing fields, if some field types of them are changed' do
      original_fields_order = RailsAdmin.config(Team).fields.map(&:name)

      RailsAdmin.config do |config|
        config.model Team do
          configure :players, :enum do
            enum { [] }
          end

          configure :revenue, :integer
        end
      end

      expect(RailsAdmin.config(Team).fields.map(&:name)).to eql(original_fields_order)
    end

    it 'allows passing multiple fields to share the same configuration' do
      target_field_names = %i[players revenue]

      original_config = RailsAdmin.config(Team).fields.select { |field| target_field_names.include?(field.name) }
      original_config.each { |field| expect(field).to be_visible }

      RailsAdmin.config do |config|
        config.model Team do
          configure target_field_names do
            visible false
          end
        end
      end

      updated_config = RailsAdmin.config(Team).fields.select { |field| target_field_names.include?(field.name) }
      updated_config.each { |field| expect(field).to_not be_visible }
    end
  end

  describe '#_fields' do
    let(:config) { RailsAdmin.config(Team) }
    before do
      RailsAdmin.config(Team) do
        field :id
        field :wins, :boolean
      end
    end

    it "does not cause FrozenError by changing exiting field's type" do
      # Reference the fields for readonly
      config.edit.send(:_fields, true)

      RailsAdmin.config(Team) do
        field :wins, :integer
      end
      expect(config.fields.map(&:name)).to match_array %i[id wins]
    end
  end
end
