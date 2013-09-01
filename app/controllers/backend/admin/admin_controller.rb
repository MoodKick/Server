module Backend module Admin
  class AdminController < BaseController
    before_filter :require_admin_access!

    def require_admin_access!
      authenticate_backend_user!
      unless principal.has_claim?(current_user, Claim::AdminAccess)
        render template: 'backend/access_denied'
      end
    end
  end
end end
