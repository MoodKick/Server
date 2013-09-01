# manage safety pla
class SafetyPlanService
  def initialize(repository)
    @repository = repository
  end

  # create safety plan for client with client_id as therapist
  # using attributes
  #FIXME: replace attributes with just 'body', since that's
  # the only attribute in use
  def create(attributes, client_id, therapist)
    safety_plan = repository.build_new(client_id)
    safety_plan.body = attributes[:body]
    safety_plan.created_by = therapist.id
    repository.add(safety_plan)
    safety_plan
  end

  # get safety plan for client_id
  def show_for_client_id(client_id, subscriber)
    safety_plan = repository.last_version_for_client_id(client_id)
    if safety_plan
      subscriber.success(safety_plan)
    else
      subscriber.success(repository.build_new(client_id))
    end
  end

  private
    attr_reader :repository
end
