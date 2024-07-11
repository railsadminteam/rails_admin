

class PaperTrailTest < ActiveRecord::Base
  class SubclassInNamespace < self
  end
end
