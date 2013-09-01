# manage survey as therapist
class TherapistSurveyService
  def initialize(questionnaire_repository,
                 answer_group_repository,
                 party_repository)
    @questionnaire_repository = questionnaire_repository
    @answer_group_repository  = answer_group_repository
    @party_repository = party_repository
  end

  # get results of questionnaire
  # for client identified by client_id
  # for questionnaire identified by questionnaire_id
  #FIXME: therapist_id is not used
  def list_questionnaire_results_for_client(
    therapist_id, client_id, questionnaire_id, subscriber)

    client = party_repository.find(client_id)
    questionnaire = questionnaire_repository.find(questionnaire_id)
    results = answer_group_repository.for_client_by_questionnaire_id(
      client_id, questionnaire_id)
    subscriber.success(questionnaire, results)
  rescue ActiveRecord::RecordNotFound => e
    subscriber.not_found
  end

  # list all questionnaire results
  # for questionnaire identified as questionnaire_id
  # for all clients of therapist
  def list_questionnaire_results(therapist, questionnaire_id, subscriber)
    questionnaire = questionnaire_repository.find(questionnaire_id)
    results = answer_group_repository.for_questionnaire_id_and_client_ids(
      questionnaire_id, therapist.client_ids)
    subscriber.success(questionnaire, results)
  end

  private
    attr_reader :questionnaire_repository
    attr_reader :answer_group_repository
    attr_reader :party_repository
end
