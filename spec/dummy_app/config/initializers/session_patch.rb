require 'action_dispatch/middleware/session/abstract_store'

# When ORM was switched, but another ORM's model class still exists in session
# (Devise saves User model to session), ActionDispatch raises ActionDispatch::Session::SessionRestoreError
# and app can't be started unless you delete your browser's cookie data.
# To prevent this situation, detect this problem here and reset session data
# so user can make another login via Devise.

ActionDispatch::Session::StaleSessionCheck.module_eval do
  def stale_session_check!
    yield
  rescue ArgumentError => argument_error
    {}
  end
end

