module Survey
  # Group of answers, as filled survey
  # for specific user and questionnaire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :questionnaire
    has_many :answers
    belongs_to :user

    def add_answer(a)
      answers << a
    end

    def answer_for_question(question)
      answers.to_a.find { |q| q.question == question }
    end
  end
end
