module Backend module Admin
  class UsersController < AdminController
    class ListResponder < Responder
      def success(users)
        render locals: { users: users }
      end
    end

    def index
      users = service.list(ListResponder.new(self))
    end

    class ShowResponder < Responder
      def success(user)
        render locals: { user: user }
      end

      def not_found
        render file: 'public/404.html',
          status: 404,
          layout: false
      end
    end

    def show
      service.show(params[:id], ShowResponder.new(self))
    end

    def edit
      service.show(params[:id], ShowResponder.new(self))
    end

    class UpdateResponder < Responder
      def success(user)
        redirect_to backend_admin_user_path(user), notice: 'User was successfully updated.'
      end

      def validation_failure(user)
        render action: :edit, locals: { user: user }
      end
    end

    def update
      service.update(params[:id], params[:user], UpdateResponder.new(self))
    end

    class DeleteResponder < Responder
      def success
        redirect_to backend_admin_users_path, notice: 'Successfully deleted user.'
      end
    end

    def destroy
      service.delete(params[:id], DeleteResponder.new(self))
    end

    class AddResponder < Responder
      def success(user)
        render locals: {
          user: user,
          errors: []
        }
      end
    end

    def new
      service.add(AddResponder.new(self))
    end

    class CreateResponder < Responder
      def success(user)
        redirect_to backend_admin_user_path(user), notice: 'User was successfully added.'
      end

      def validation_failure(user)
        render action: :new, locals: {
          user: user,
          errors: user.errors.full_messages
        }
      end
    end

    def create
      service.create(params[:user], CreateResponder.new(self))
    end

    private
      def service
        ServiceContainer.admin_users_service
      end
  end
end end
