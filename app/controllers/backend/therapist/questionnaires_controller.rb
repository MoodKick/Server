module Backend module Therapist
  class QuestionnairesController < BaseController
    def index
      render locals: {
        questionnaires: ServiceContainer.survey_service.list_questionnaires
      }
    end
  end
end end
