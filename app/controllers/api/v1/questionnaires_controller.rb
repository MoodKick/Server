module Api
  module V1
    class QuestionnairesController < ApiController
      before_filter :authenticate_user!

      def index
        @questionnaires = service.list_questionnaires

        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      private
        def service
          ServiceContainer.survey_service
        end
    end
  end
end
