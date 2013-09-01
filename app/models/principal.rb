class Principal
  class UnknownClaim < StandardError
  end

  def has_claim?(user, claim)
    return false unless user
    res = if claim == Claim::ClientAccess
      user.has_role?(Role::Client)
    elsif claim == Claim::AdminAccess
      user.has_role?(Role::Admin)
    elsif claim == Claim::TherapistAccess
      user.has_role?(Role::Therapist)
    else
      raise UnknownClaim
    end
    res
  end
end
