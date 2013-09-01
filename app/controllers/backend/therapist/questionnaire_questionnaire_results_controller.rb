module Backend module Therapist
  class QuestionnaireQuestionnaireResultsController < BaseController
    class IndexResponder < Responder
      def success(questionnaire, results)
        render locals: {
          questionnaire: questionnaire,
          questionnaire_results: results
        }
      end
    end

    def index
      ServiceContainer.therapist_survey_service.
        list_questionnaire_results(
          current_user, params[:questionnaire_id],
          IndexResponder.new(self))
    end
  end
end end
