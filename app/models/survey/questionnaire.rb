module Survey
  # group of questions
  class Questionnaire < ActiveRecord::Base
    has_many :questions

    def add_question(n, q)
      q.position = n
      self.questions << q
    end

    # question by it's position
    def question_by_n(n)
      self.questions.to_a.find { |q| q.position == n }
    end
  end
end
