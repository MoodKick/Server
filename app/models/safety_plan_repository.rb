class SafetyPlanRepository
  def delete_all
    SafetyPlan.delete_all
  end

  def add(safety_plan)
    safety_plan.save
  end

  def last_version_for_client_id(client_id)
    SafetyPlan.where(client_id: client_id).
      order(:created_at).last
  end

  def build_new(client_id)
    SafetyPlan.new do |p|
      p.client_id = client_id
    end
  end
end
