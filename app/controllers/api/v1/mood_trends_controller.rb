module Api
  module V1
    class MoodTrendsController < ApiController
      before_filter :authenticate_user!

      def show
        @report = MoodTrendReport.new(current_user, 30)
      end
    end
  end
end

