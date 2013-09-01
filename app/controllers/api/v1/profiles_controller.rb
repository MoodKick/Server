module Api
  module V1
    class ProfilesController < ApiController
      before_filter :authenticate_user!

      def show
        @profile = current_user
      end

      def update
        @profile = current_user

        respond_to do |format|
          if @profile.update_attributes(params[:profile])
            format.json { head :no_content }
          else
            format.json { render json: @profile.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end
end
