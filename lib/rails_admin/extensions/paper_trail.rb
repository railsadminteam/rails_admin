require 'rails_admin/extensions/paper_trail/auditing_adapter'

RailsAdmin.add_extension(:paper_trail, RailsAdmin::Extensions::PaperTrail,
                         auditing: true
)
