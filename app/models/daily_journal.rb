# entry of daily journal
#FIXME: should be called DailyJournalEntry
class DailyJournal < ActiveRecord::Base
  mount_uploader :audio, AudioUploader
  mount_uploader :video, VideoUploader
  belongs_to :user

  def can_be_edited?
    created_at > 1.day.ago
  end

  # array of strings representing each state
  def keywords
    res = []
    res << 'Calm' if calm
    res << 'Angry' if angry
    res << 'Anxious' if anxious
    res << 'Manic' if manic
    res
  end

  def has_audio?
    audio?
  end

  def has_video?
    video?
  end
end
