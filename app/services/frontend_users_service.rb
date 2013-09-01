# manage users for frontend app
class FrontendUsersService
  def initialize(repository)
    @repository = repository
  end

  # get all users except one with id == exluding_id
  def list_excluding(excluding_id)
    repository.public_excluding_id(excluding_id)
  end

  # get user by id
  def show(id)
    repository.public_by_id(id)
  end

  private
    attr_reader :repository
end
