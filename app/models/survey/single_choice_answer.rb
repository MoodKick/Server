module Survey
  # answer which may have only single option selected
  class SingleChoiceAnswer < SingleValueAnswer
    def answer
      question.choice_by_id(choice_id).value
    end

    def response
      answer
    end
  end
end
