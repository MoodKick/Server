module Backend module Therapist
  class ClientDailyJournalEntriesController < BaseController
    def index
      current_user.authorize!(:manage, User)
      @client = current_user.client_by_id(params[:client_id])
      @daily_journal_entries = @client.daily_journal_entries_sorted_by_created_at
    end

    def show
      current_user.authorize!(:manage, User)
      @client = current_user.client_by_id(params[:client_id])
      @daily_journal_entry = @client.daily_journal_entry_by_id(params[:id])
    end
  end
end end
