# managing user roles as an admin
class AdminUserRolesService
  def initialize(user_repository, role_repository)
    @user_repository = user_repository
    @role_repository = role_repository
  end

  # list all users by user_id
  def list(user_id, subscriber)
    user = user_repository.find_by_id(user_id)
    subscriber.success(user, role_repository.all, user.roles)
  end

  # add user by user_id and role_name
  def add(user_id, role_name, subscriber)
    role = role_repository.by_name(role_name)
    user = user_repository.find_by_id(user_id)
    if role && user
      user.add_role(role)
      user_repository.update(user)
      subscriber.success(user)
    else
      subscriber.not_found
    end
  end

  # remove user by user_id and role_name
  def remove(user_id, role_name, subscriber)
    role = role_repository.by_name(role_name)
    user = user_repository.find_by_id(user_id)
    if role && user
      user.remove_role(role)
      user_repository.update(user)
      subscriber.success(user)
    else
      subscriber.not_found
    end
  end

  private
    attr_reader :user_repository, :role_repository
end
