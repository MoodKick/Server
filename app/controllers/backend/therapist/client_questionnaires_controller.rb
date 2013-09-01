module Backend module Therapist
  class ClientQuestionnairesController < BaseController
    def index
      @client = current_user.client_by_id(params[:client_id])
      @questionnaires = ServiceContainer.survey_service.list_questionnaires
    end
  end
end end
