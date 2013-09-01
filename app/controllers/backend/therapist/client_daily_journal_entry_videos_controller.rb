module Backend module Therapist
  class ClientDailyJournalEntryVideosController < BaseController
    def show
      client = current_user.client_by_id(params[:client_id])
      daily_journal_entry = client.daily_journal_entry_by_id(params[:daily_journal_entry_id])
      send_file daily_journal_entry.video.path, disposition: 'inline', x_sendfile: true
    end
  end
end end
