# frozen_string_literal: true

class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams

  if ActiveRecord.gem_version >= Gem::Version.new('7.1') || defined?(CompositePrimaryKeys)
    has_many :fanships, inverse_of: :fan
    has_one :fanship, inverse_of: :fan
  end

  validates_presence_of(:name)
end
