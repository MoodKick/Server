# manage users as an admin
class AdminUsersService
  def initialize(repository)
    @repository = repository
  end

  # list all users
  def list(subscriber)
    subscriber.success(repository.all)
  end

  # get user by id for showing
  def show(id, subscriber)
    user = repository.find_by_id(id)
    if user
      subscriber.success(user)
    else
      subscriber.not_found
    end
  end

  # build new user
  def add(subscriber)
    subscriber.success(repository.build_new)
  end

  # build user from user_params and persist
  def create(user_params, subscriber)
    user = repository.build_new
    user.username = user_params[:username]
    user.full_name = user_params[:full_name]
    user.location = user_params[:location]
    user.email = user_params[:email]
    user.description = user_params[:description]
    user.password = user_params[:password]
    user.password_confirmation = user_params[:password_confirmation]
    if repository.add(user)
      subscriber.success(user)
    else
      subscriber.validation_failure(user)
    end
  end

  # update user by user_id taking user_params
  def update(user_id, user_params, subscriber)
    user = repository.find_by_id(user_id)
    if user.update_attributes(user_params)
      subscriber.success(user)
    else
      subscriber.validation_failure(user)
    end
  end

  # delete user by id
  def delete(id, subscriber)
    repository.remove(id)
    subscriber.success
  end

  private
    attr_reader :repository
end
