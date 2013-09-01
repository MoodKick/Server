module Survey
  class SurveyService
    def initialize(questionnaire_repository, answer_group_repository)
      @questionnaire_repository = questionnaire_repository
      @answer_group_repository  = answer_group_repository
    end

    # all questionnaires
    def list_questionnaires
      questionnaire_repository.all
    end

    # provide answer for given user, questionnaire
    def answer(user_id, questionnaire_id, answer_params)
      questionnaire = questionnaire_repository.find(questionnaire_id)
      answer_group = ::Survey::AnswerGroup.new
      answer_group.questionnaire = questionnaire
      answer_group.user_id = user_id

      raise 'Wrong answer params' unless answer_params.respond_to?(:map)
      answer_params.map do |n, answer_param|
        question = questionnaire.question_by_n(n.to_i)
        answer = if question.kind_of? ::Survey::MeasurableQuestion
          ::Survey::MeasurableAnswer.new(value: answer_param['value'])
        elsif question.kind_of? ::Survey::SingleChoiceQuestion
          ::Survey::SingleChoiceAnswer.new(choice_id: answer_param['choice_id'])
        elsif question.kind_of? ::Survey::TextQuestion
          ::Survey::TextAnswer.new(text: answer_param['text'])
        elsif question.kind_of? ::Survey::MultipleChoiceQuestion
          ::Survey::MultipleChoiceAnswer.new(choice_ids: answer_param['choice_ids'])
        else
          raise 'unknown question'
        end
        answer.question = question

        answer_group.add_answer(answer)
      end
      answer_group_repository.add(answer_group)
      answer_group
    end

    private
      attr_reader :answer_group_repository,
                  :questionnaire_repository
  end
end
