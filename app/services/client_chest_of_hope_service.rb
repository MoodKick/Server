# manage chest of hope as a client
class ClientChestOfHopeService
  def initialize(repository)
    @repository = repository
  end

  # get item for client by id
  def find(client, id, subscriber)
    item = repository.by_client_id_and_id(client.id, id)
    subscriber.success(item)
  end

  #FIXME: not needed
  def add_hope_item(client, title)
    item = repository.build_new(client.id, title: title)
    repository.add(item)
  end

  # get list of items for client
  def list(client, subscriber)
    subscriber.success(repository.for_client_id(client.id))
  end

  # build new text item for client
  def build_new_text(client)
    repository.build_new(client.id, type: 'text')
  end

  # update text item for client by id, using title and text
  def update_text(client, id, title, text, subscriber)
    item = repository.by_client_id_and_id(client.id, id)
    if title.nil? || title == ''
      subscriber.not_valid(item, [:title_blank])
    else
      item.title = title
      item.text = text
      repository.update(item)
      subscriber.success(item)
    end
  end

  # persist new text item for client using title and text
  def add_text(client, title, text, subscriber)
    item = repository.build_new(client.id, {
      title: title, text: text, type: 'text'
    })
    if title.nil? || title == ''
      subscriber.not_valid(item, [:title_blank])
    else
      repository.add(item)
      subscriber.success
    end
  end

  # delete item for client by id
  def delete(client, id, subscriber)
    repository.delete(client.id, id)
    subscriber.success
  end

  private
    attr_reader :repository
end
