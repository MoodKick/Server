module Api
  module V1
    class DailyJournalAudiosController < ApiController
      before_filter :authenticate_user!

      def create
        @daily_journal = current_user.daily_journals.find(params[:daily_journal_id])
        @daily_journal.audio = params[:daily_journal][:audio]
        if @daily_journal.save
          render status: :created
        else
          render json: @daily_journal.errors, status: :unprocessable_entity
        end
      end

      def show
        @daily_journal = current_user.daily_journals.find(params[:daily_journal_id])
        send_file @daily_journal.audio.path, type: "audio/3gpp", x_sendfile: true
      end
    end
  end
end
