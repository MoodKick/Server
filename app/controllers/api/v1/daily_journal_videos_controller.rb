module Api
  module V1
    class DailyJournalVideosController < ApiController
      before_filter :authenticate_user!

      def create
        @daily_journal = current_user.daily_journals.find(params[:daily_journal_id])
        @daily_journal.video = params[:daily_journal][:video]
        if @daily_journal.save
          render status: :created
        else
          render json: @daily_journal.errors, status: :unprocessable_entity
        end
      end

      def show
        @daily_journal = current_user.daily_journals.find(params[:daily_journal_id])
        send_file @daily_journal.video.path, type: "video/3gpp", x_sendfile: true
      end
    end
  end
end
