module Backend module Therapist
  class ClientMoodTrendsController < BaseController
    def show
      client = current_user.client_by_id(params[:client_id])
      @report = MoodTrendReport.new(client, 30)
    end
  end
end end
