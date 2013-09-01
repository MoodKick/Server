module Api
  module V1
    class BrochuresController < ApiController
      before_filter :authenticate_user!

      def show
        @brochure = brochure_by_type(params[:id])
        respond_to do |format|
          format.json { render status: 200 }
        end
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
    end
  end
end
