module Backend module Therapist
  class TherapistController < BaseController
    before_filter :require_therapist_access!

    def require_therapist_access!
      authenticate_backend_user!
      unless principal.has_claim?(current_user, Claim::TherapistAccess)
        render template: 'backend/access_denied'
      end
    end
  end
end end
