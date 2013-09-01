# manage therapists as an admin
class TherapistService
  def initialize(party_repository)
    @party_repository = party_repository
  end

  # Subscriber which does nothing
  class NullSubscriber
    def success(therapist)
    end

    def client_not_found
    end
  end

  # make therapist with id == therapist_id a primary therapist
  # for client with id == client_id
  def make_primary_therapist(client_id, therapist_id,
                             subscriber=NullSubscriber.new)
    client = party_repository.find_by_id(client_id)
    #TODO: add check for permission
    if client
      therapist = party_repository.find_by_id(therapist_id)
      client.make_primary_therapist(therapist)
      client.save!
      subscriber.success(therapist)
    else
      subscriber.client_not_found
    end
  end

  private
    attr_reader :party_repository

end
