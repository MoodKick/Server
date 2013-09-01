module Survey
  # manages collection of questionnaires
  class QuestionnaireRepository
    def delete_all
      ::Survey::Questionnaire.delete_all
    end

    def add(questionnaire)
      questionnaire.save
    end

    def find(id)
      ::Survey::Questionnaire.find(id)
    end

    def find_by_id(id)
      ::Survey::Questionnaire.find_by_id(id)
    end

    def all
      ::Survey::Questionnaire.all
    end
  end
end
