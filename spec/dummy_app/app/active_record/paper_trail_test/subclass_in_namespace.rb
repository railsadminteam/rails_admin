# frozen_string_literal: true

class PaperTrailTest < ActiveRecord::Base
  class SubclassInNamespace < self
  end
end
