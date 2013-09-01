module Api
  module V1
    class AvatarsController < ApiController
      before_filter :authenticate_user!

      def index
        @avatars = Avatar.all
        respond_to do |format|
          format.json { render status: 200 }
        end
      end
    end
  end
end
