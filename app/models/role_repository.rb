class RoleRepository
  def all
    [Role::Therapist, Role::Client, Role::Relative, Role::Admin]
  end

  def by_name(name)
    all.find { |r| r.to_s == name }
  end
end
