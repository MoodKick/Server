json.array! @daily_journals do |json, daily_journal|
  json.id daily_journal.id
  json.angry daily_journal.angry
  json.anxious daily_journal.anxious
  json.calm daily_journal.calm
  json.manic daily_journal.manic
  json.happiness_level daily_journal.happiness_level
  json.name daily_journal.name
  json.description daily_journal.description
  json.created_at daily_journal.created_at
  json.has_audio !daily_journal.audio.url.nil?
  json.has_video !daily_journal.video.url.nil?
end