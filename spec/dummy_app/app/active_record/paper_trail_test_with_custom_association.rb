class Trail < PaperTrail::Version
  self.table_name = :custom_versions
end

class PaperTrailTestWithCustomAssociation < ActiveRecord::Base
  self.table_name = :paper_trail_tests
  has_paper_trail versions: {class_name: 'Trail'}
end
