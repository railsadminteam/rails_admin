class PaperTrailTestWithCustomAssociation < ActiveRecord::Base
  self.table_name = :paper_trail_tests
  has_paper_trail versions: {name: :trails}
end
