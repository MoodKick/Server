module Backend module Therapist
  class ClientsController < BaseController
    def index
      current_user.authorize!(:manage, User)
      render locals: {
        clients: current_user.clients.paginate(page: params[:page])
      }
    end

    def show
      current_user.authorize!(:manage, User)
      render locals: {
        client: current_user.clients.find(params[:id])
      }
    end

  end
end end
