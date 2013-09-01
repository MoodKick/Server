module Api
  module V1
    class AnswerGroupsController < ApiController
      before_filter :authenticate_user!

      def create
        answer = if params[:answer].kind_of? String
                   JSON.load(params[:answer])
                 else
                   params[:answer]
                 end
        service.answer(current_user.id, params[:questionnaire_id],
                       answer)

        respond_to do |format|
          format.json { render status: :created, text: '' }
        end
      end

      private
        def service
          ServiceContainer.survey_service
        end
    end
  end
end

