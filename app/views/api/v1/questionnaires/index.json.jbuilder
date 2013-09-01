json.array! @questionnaires do |json, questionnaire|
  json.id questionnaire.id
  json.title questionnaire.title
  json.questions questionnaire.questions do |json, question|
    json.id question.id
    json.position question.position
    json.description question.description
    if question.kind_of?(Survey::MeasurableQuestion)
      json.type 'measurable'
      json.answer question.unit.default_value
      json.unit do |json|
        json.min_value question.unit.min_value
        json.max_value question.unit.max_value
        json.default_value question.unit.default_value
        json.min_value_description question.unit.min_value_description
        json.max_value_description question.unit.max_value_description
      end
    elsif question.kind_of?(Survey::SingleChoiceQuestion)
      json.type 'single_choice'
      json.answer question.choices.first.id
      json.choices question.choices do |json, choice|
        json.id choice.id
        json.value choice.value
      end
    elsif question.kind_of?(Survey::TextQuestion)
      json.type 'text'
    elsif question.kind_of?(Survey::MultipleChoiceQuestion)
      json.type 'multiple_choice'
      json.choices question.choices do |json, choice|
        json.id choice.id
        json.value choice.value
      end
    end
  end
end
