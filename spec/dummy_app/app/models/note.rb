class Note
  include Mongoid::Document

  embedded_in :article
  field :subject, :type => String
  field :description, :type => String
end
