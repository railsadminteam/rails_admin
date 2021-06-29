class PaperTrailTestWithCustomAssociation < ActiveRecord::Base
  self.table_name = :paper_trail_tests
  if PaperTrail::VERSION::MAJOR >= 10
    has_paper_trail versions: {name: :trails}
  else
    has_paper_trail versions: :trails
  end
end
