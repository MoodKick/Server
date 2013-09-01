require_relative '../../app/services/therapist_service'

describe TherapistService do
  let(:party_repository) { stub }
  subject { TherapistService.new(party_repository) }

  describe '#make_primay_therapist' do
    let(:client_id) { 1234 }
    let(:therapist_id) { 4321 }
    let(:client) { stub }
    let(:therapist) { stub }

    before do
      party_repository.stub!(:find_by_id).with(therapist_id) { therapist }
    end
    let(:subscriber) { stub }

    context 'when there is a client with given id' do
      before do
        party_repository.stub!(:find_by_id).with(client_id) { client }
        client.stub!(:make_primary_therapist)
        client.stub!(:save!)
        subscriber.stub!(:success)
      end

      it 'succeeds' do
        subscriber.should_receive(:success).
          with(therapist)
        subject.make_primary_therapist(client_id, therapist_id, subscriber)
      end

      it 'changes primary therapist of client' do
        client.should_receive(:make_primary_therapist).with(therapist)
        client.should_receive(:save!)

        subject.make_primary_therapist(client_id, therapist_id, subscriber)
      end
    end

    context 'when client cannot be found' do
      it 'tells subscriber about problem' do
        party_repository.stub!(:find_by_id).with(client_id) { nil }
        subscriber.should_receive(:client_not_found)

        subject.make_primary_therapist(client_id, therapist_id, subscriber)
      end
    end
  end
end
