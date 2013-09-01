module MoodKick
  module Test
    class DailyJournalEntriesGenerator
      def self.generate(client, n_entries=40)
        calm_days    = random_array_with_n_true(n_entries, 5)
        angry_days   = random_array_with_n_true(n_entries, 7)
        manic_days   = random_array_with_n_true(n_entries, 40)
        anxious_days = random_array_with_n_true(n_entries, 21)

        0.upto(n_entries-1) do |i|
          random_sample = [1, 2, 3, 4].sample(rand(4)+1)
          client.daily_journals.create({
            calm: calm_days[i],
            angry: angry_days[i],
            manic: manic_days[i],
            anxious: anxious_days[i],
            created_at: i.days.ago,
            happiness_level: rand(5)
          })
        end
      end

      def self.random_array_with_n_true(size, n)
        res = Array.new(n) { true }
        res += Array.new(size - n) { false }
        res.shuffle
      end
    end
  end
end
