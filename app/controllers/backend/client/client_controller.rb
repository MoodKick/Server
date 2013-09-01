module Backend module Client
  class ClientController < BaseController
    before_filter :require_client_access!

    def require_client_access!
      authenticate_backend_user!
      unless principal.has_claim?(current_user, Claim::ClientAccess)
        render template: 'backend/access_denied'
      end
    end
  end
end end
