# This file adds a method to the Pundit module that is logically
# equivalent to Pundit#policy_scope, except when there is no
# policy scope, nil is returned instead of raising a
# Pundit::NotDefinedError.
#
# In addition to allowing us to avoid using exceptions as
# flow-control, this bypasses any time consuming things that may occur
# when the exception is created.
#
# In specific, this avoids sending inspect to an
# ActiveRecord::Relation, which can be an exceedingly expensive
# operation if that relation, for example, describes over a million
# rows.
if defined?(Pundit)
  module Pundit
    def policy_scope_or_nil(scope)
      policy_scopes[scope] ||= Pundit.policy_scope(pundit_user, scope)
    end
  end
end
