module Backend
  class HomeController < BaseController
    before_filter :authenticate_backend_user!

    def show
    end
  end
end
