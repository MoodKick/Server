module Api
  module V1
    class MessagesController < ApiController
      before_filter :authenticate_user!

      def index
        @messages = current_user.messages.for_last_day

        respond_to do |format|
          format.json { render status: 200 }
        end
      end
    end
  end
end
