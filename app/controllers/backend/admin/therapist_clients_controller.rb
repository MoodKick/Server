module Backend module Admin
  class TherapistClientsController < AdminController
    def new
      #FIXME: check permissions
      render locals: { errors: [] }
    end

    class CreateResponse < Responder
      def success(therapist)
        redirect_to backend_admin_user_path(therapist), notice: 'Client was successfully associated.'
      end

      def client_not_found
        render action: :new, locals: { errors: ['Unable to find this user'] }
      end
    end

    def create
      therapist_service.make_primary_therapist(
        params[:client_association][:client_id],
        params[:therapist_id],
        CreateResponse.new(self))
    end

    private
      def therapist_service
        ServiceContainer.therapist_service
      end
  end
end end
