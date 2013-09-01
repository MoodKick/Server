module Backend module Therapist
  class ClientQuestionnaireResultsController < BaseController
    class IndexResponder < Responder
      def success(questionnaire, results)
        render locals: {
          questionnaire: questionnaire,
          questionnaire_results: results
        }
      end

      def not_found
        render file: 'public/404.html',
          status: 404,
          layout: false
      end
    end

    def index
      ServiceContainer.therapist_survey_service.
        list_questionnaire_results_for_client(
          current_user, params[:client_id], params[:questionnaire_id],
          IndexResponder.new(self))
    end
  end
end end
