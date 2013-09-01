module Api
  module V1
    class UsersController < ApiController
      before_filter :authenticate_user!

      def index
        @users = service.list_excluding(current_user.id)
        @owner = current_user

        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      def show
        @user = service.show(params[:id])
        @owner = current_user

        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      private
        def service
          ServiceContainer.frontend_users_service
        end
    end
  end
end
