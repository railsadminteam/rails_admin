# Mass-assignment protection

Only visible fields are editable in RailsAdmin. Others will get caught and sanitized.

Basically you don't need to protect your attributes in RailsAdmin.

However, `:attr_accessible` and `:attr_protected` are taken into account: restricted fields are not editable (read_only).
If you whitelist attributes, don't forget to whitelist accessible associations' 'id' methods as well : `division_id`, `player_ids`, `commentable_type`, `commentable_id`, etc.

`:attr_accessible` specifies a list of accessible methods for mass-assignment in your ActiveModel models.
