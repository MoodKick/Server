module Survey
  Choice # autoload it

  # may have multiple choices
  class MultipleChoiceAnswer < Answer
    serialize :choice_ids, Array

    def response
      choice_ids.map do |choice_id|
        question.choice_by_id(choice_id).value
      end.join(', ')
    end
  end
end
