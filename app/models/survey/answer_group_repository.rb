module Survey
  # Manages collection of answer groups
  class AnswerGroupRepository
    def delete_all
      AnswerGroup.delete_all
    end

    def add(answer_group)
      answer_group.save
    end

    def find(id)
      AnswerGroup.find(id)
    end

    def all
      AnswerGroup.all
    end

    def for_client_by_questionnaire_id(client_id, questionnaire_id)
      Survey::AnswerGroup.where(user_id: client_id,
                                questionnaire_id: questionnaire_id)
    end

    def for_questionnaire_id_and_client_ids(questionnaire_id, client_ids)
      Survey::AnswerGroup.where(questionnaire_id: questionnaire_id).
        where(user_id: client_ids)
    end

  end
end
