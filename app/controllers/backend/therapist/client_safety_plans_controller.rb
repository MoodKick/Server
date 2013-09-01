module Backend module Therapist
  class ClientSafetyPlansController < BaseController
    class ShowResponder < Responder
      def success(safety_plan)
        render locals: {
          safety_plan: safety_plan
        }
      end
    end

    def show
      service.show_for_client_id(params[:client_id],
                                 ShowResponder.new(self))
    end

    def edit
      service.show_for_client_id(params[:client_id],
                                 ShowResponder.new(self))
    end

    def create
      safety_plan = service.create(params[:safety_plan],
                                   params[:client_id],
                                   current_user)
      redirect_to backend_therapist_client_safety_plan_path({
        client_id: safety_plan.client_id
      })
    end

    def update
      safety_plan = service.create(params[:safety_plan],
                                   params[:client_id],
                                   current_user)
      redirect_to backend_therapist_client_safety_plan_path({
        client_id: safety_plan.client_id
      })
    end

    private
      def service
        ServiceContainer.safety_plan_service
      end
  end
end end
