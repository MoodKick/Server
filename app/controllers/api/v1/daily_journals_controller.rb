module Api
  module V1
    class DailyJournalsController < ApiController
      before_filter :authenticate_user!

      def index
        @daily_journals = current_user.daily_journals

        respond_to do |format|
          format.json
        end
      end

      def show
        @daily_journal = current_user.daily_journals.find(params[:id])

        respond_to do |format|
          format.json { render json: @daily_journal }
        end
      end

      def create
        @daily_journal = DailyJournal.new(params[:daily_journal])
        @daily_journal.user = current_user

        respond_to do |format|
          if @daily_journal.save
            format.json { render status: :created, location: api_v1_daily_journal_path(@daily_journal) }
          else
            format.json { render json: @daily_journal.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        @daily_journal = current_user.daily_journals.find(params[:id])

        respond_to do |format|
          if @daily_journal.can_be_edited?
            if @daily_journal.update_attributes(params[:daily_journal])
              format.json { head :no_content }
            else
              format.json { render json: @daily_journal.errors, status: :unprocessable_entity }
            end
          else 
            format.json { render json: { message: 'Daily journal is too old' }, status: :unprocessable_entity }
          end
        end
      end
    end
  end
end
