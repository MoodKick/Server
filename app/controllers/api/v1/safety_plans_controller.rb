module Api
  module V1
    class SafetyPlansController < ApiController
      before_filter :authenticate_user!

      class ShowResponder < Responder
        def success(safety_plan)
          render locals: {
            safety_plan: safety_plan
          }
        end
      end

      def show
        service.show_for_client_id(current_user.id,
                                   ShowResponder.new(self))
      end

      private
        def service
          ServiceContainer.safety_plan_service
        end
    end
  end
end
