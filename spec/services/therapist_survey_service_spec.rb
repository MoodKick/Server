require_relative '../../app/services/therapist_survey_service'

unless defined?(ActiveRecord::RecordNotFound)
  module ActiveRecord
    class RecordNotFound < Exception
    end
  end
end

describe TherapistSurveyService do
  subject do
    TherapistSurveyService.new(questionnaire_repository,
                               answer_group_repository,
                               party_repository)
  end
  let(:questionnaire_repository) { stub(find: nil) }
  let(:answer_group_repository) { stub }
  let(:party_repository) { stub }
  let(:therapist) { stub(client_ids: client_ids) }
  let(:questionnaire_id) { 4321 }
  let(:subscriber) { stub }
  let(:questionnaire) { stub }
  let(:results) { [stub, stub] }
  let(:client_ids) { [311, 312, 313] }

  describe '#list_questionnaire_results' do
    context 'when everything is fine' do
      it 'notifies about success to subscriber with questionnaire
          and results' do
        questionnaire_repository.stub!(:find).with(questionnaire_id) {
          questionnaire }
        answer_group_repository.stub!(:for_questionnaire_id_and_client_ids).with(
          questionnaire_id, client_ids) { results }
        subscriber.should_receive(:success).
          with(questionnaire, results)

        subject.list_questionnaire_results(
          therapist, questionnaire_id, subscriber)
      end
    end
  end

  describe '#list_questionnaire_results_for_client' do
    let(:client_id) { 1234 }
    let(:client) { stub }

    before do
      answer_group_repository.stub!(:for_client_by_questionnaire_id)
      party_repository.stub!(:find)
    end

    context 'when everything is fine' do
      it 'notifies about success to subscriber with questionnaire
          and results' do

        party_repository.stub!(:find).with(client_id) { client }
        answer_group_repository.stub!(:for_client_by_questionnaire_id).
          with(client_id, questionnaire_id) { results }
        questionnaire_repository.stub!(:find).with(questionnaire_id) {
          questionnaire
        }

        subscriber.should_receive(:success).
          with(questionnaire, results)

        subject.list_questionnaire_results_for_client(
          therapist, client_id, questionnaire_id, subscriber
        )
      end
    end

    context 'when client cannot be found' do
      it 'tells subscriber about it' do
        party_repository.stub!(:find).with(client_id) {
          raise ActiveRecord::RecordNotFound
        }
        subscriber.should_receive(:not_found)
        subject.list_questionnaire_results_for_client(
          therapist, client_id, questionnaire_id, subscriber
        )
      end
    end
  end
end
