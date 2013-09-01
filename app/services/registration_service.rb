# user creation/registrations
class RegistrationService
  #FIXME: use repository
  def initialize(party_repository=nil)
    @party_repository = party_repository
  end

  # create user by attributes
  def register_user(attributes)
    user = User.new(attributes)
    user.save
    user
  end

  # create user by attributes with Therapist role
  def register_therapist(attributes)
    user = register_user(attributes)
    user.add_role(Role::Therapist)
    user.save
    user
  end

  # create user by attributes with Client role
  def register_client(attributes)
    user = register_user(attributes)
    user.add_role(Role::Client)
    user.save
    user
  end

  # create user by attributes with Relative role
  def register_relative(attributes)
    user = register_user(attributes)
    user.add_role(Role::Relative)
    user.save
    user
  end

  # create user by attributes with Admin role
  def register_admin(attributes)
    user = register_user(attributes)
    user.add_role(Role::Admin)
    user.save
    user
  end

  private
    attr_reader :user_repository
end
