class PartyRepository
  def delete_all
    User.delete_all
  end

  def add(user)
    user.save
  end

  def build_new
    User.new
  end

  def update(user)
    user.save
  end

  def all
    User.all
  end

  def therapists
    User.all.select { |u| u.has_role?(Role::Therapist) }
  end

  def clients
    User.all.select { |u| u.has_role?(Role::Client) }
  end

  def relatives
    User.all.select { |u| u.has_role?(Role::Relative) }
  end

  def find(id)
    User.find(id)
  end

  def find_client(id)
    id = id.to_i
    clients.detect { |u| u.id == id }
  end

  def find_therapist(id)
    id = id.to_i
    therapists.detect { |u| u.id == id }
  end

  def find_relative(id)
    id = id.to_i
    relatives.detect { |u| u.id == id }
  end

  def remove(id)
    User.delete(id)
  end

  def remove_client(id)
    client = find_client(id)
    client.delete if client
  end

  def remove_therapist(id)
    therapist = find_therapist(id)
    therapist.delete if therapist
  end

  def remove_relative(id)
    relative = find_relative(id)
    relative.delete if relative
  end

  def find_by_username(username)
    User.where(username: username).first
  end

  def find_by_id(id)
    User.find_by_id(id)
  end

  def public_excluding_id(excluding_id)
    excluding_id = excluding_id.to_i

    User.all.find_all { |u| public_user?(u) }.
      reject { |u| u.id == excluding_id }
  end

  def public_by_id(id)
    id = id.to_i

    user = find_by_id(id)
    if public_user?(user)
      user
    else
      nil
    end
  end

  private
    def public_user?(user)
      !user.has_role?(Role::Admin)
    end
end
