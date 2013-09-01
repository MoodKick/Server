module Backend module Therapist
  class QuestionnaireResultsController < BaseController
    def show
      render locals: {
        questionnaire_result: Survey::AnswerGroup.find(params[:id]),
      }
    end
  end
end end
