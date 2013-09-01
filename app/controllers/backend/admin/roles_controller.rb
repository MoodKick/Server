module Backend module Admin
  class RolesController < AdminController
    class ListResponder < Responder
      def success(user, all_roles, existing_roles)
        render locals: {
          user: user,
          all_roles: all_roles,
          existing_roles: existing_roles
        }
      end
    end

    def index
      service.list(params[:user_id], ListResponder.new(self))
    end

    class AddResponder < Responder
      def success(user)
        redirect_to backend_admin_user_roles_path(user), notice: 'Successfully added role.'
      end
    end

    def create
      service.add(params[:user_id], params[:name], AddResponder.new(self))
    end

    class RemoveResponder < Responder
      def success(user)
        redirect_to backend_admin_user_roles_path(user), notice: 'Successfully removed role.'
      end
    end

    def destroy
      service.remove(params[:user_id], params[:name], RemoveResponder.new(self))
    end

    private
      def service
        ServiceContainer.admin_user_roles_service
      end
  end
end end
