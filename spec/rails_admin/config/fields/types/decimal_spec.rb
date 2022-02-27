# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Decimal do
  it_behaves_like 'a float-like field type', :float_field
end
