module Backend module Therapist
  class BrochuresController < BaseController
    def index
    end

    def show
      @brochure = brochure_by_type(params[:id])
    end

    def edit
      @brochure = brochure_by_type(params[:id])
    end

    def update
      update_brochure_by_type(params[:id], params[:brochure][:body])
      redirect_to backend_therapist_brochure_path(id: params[:id])
    end

    private
      def service
        ServiceContainer.brochure_service
      end

      def brochure_by_type(type)
        case type
        when 'help'
          service.get_help
        when 'suicidal_thoughts'
          service.get_suicidal_thoughts
        when 'advice_for_relatives'
          service.get_advice_for_relatives
        end
      end

      def update_brochure_by_type(type, body)
        case type
        when 'help'
          service.update_help(body)
        when 'suicidal_thoughts'
          service.update_suicidal_thoughts(body)
        when 'advice_for_relatives'
          service.update_advice_for_relatives(body)
        end
      end
  end
end end
