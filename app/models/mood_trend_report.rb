class MoodTrendReport
  def initialize(client, n_days)
    @client = client
    @n_days = n_days
    @date_clock = Date
  end

  attr_reader :client
  attr_writer :date_clock

  def entries
    @client.daily_journal_entries_for_last_n_days(@n_days)
  end
  private :entries

  def entries_number_marked_with(type)
    entries.count(&type)
  end
  private :entries_number_marked_with

  def marked_with_anger
    entries_number_marked_with(:angry)
  end

  def marked_with_calmness
    entries_number_marked_with(:calm)
  end

  def marked_with_anxiety
    entries_number_marked_with(:anxious)
  end

  def marked_with_mania
    entries_number_marked_with(:manic)
  end

  def start_date
    @date_clock.today - @n_days
  end

  def end_date
    @date_clock.today
  end

  def number_of_days
    @n_days
  end

  def best_day_rank(entry)
    entry.happiness_level * 8 + (entry.calm ? 1 : 0)
  end
  private :best_day_rank

  def best_day
    kind_of_day(entries.sort do |entry1, entry2|
      best_day_rank(entry1) - best_day_rank(entry2)
    end.last)
  end

  def worst_day_rank(entry)
    -(entry.happiness_level * 8) + (entry.anxious ? 1 : 0) + (entry.angry ? 1 : 0) + (entry.manic ? 1 : 0)
  end
  private :worst_day_rank

  def kind_of_day(entry)
    if entry
      entry.created_at
    else
      nil
    end
  end
  private :kind_of_day

  def worst_day
    kind_of_day(entries.sort do |entry1, entry2|
      worst_day_rank(entry1) - worst_day_rank(entry2)
    end.last)
  end

  def happiness_levels
    entries.map(&:happiness_level)
  end

end
