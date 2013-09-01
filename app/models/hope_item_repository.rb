class HopeItemRepository
  def delete_all
    HopeItem.delete_all
  end

  def build_new(client_id, attributes)
    HopeItem.new({ client_id: client_id }.merge(attributes))
  end

  def add(hope_item)
    hope_item.save
  end

  def for_client_id(client_id)
    HopeItem.where(client_id: client_id)
  end

  def by_client_id_and_id(client_id, id)
    for_client_id(client_id).find_by_id(id)
  end

  def delete(client_id, id)
    for_client_id(client_id).find_by_id(id).destroy
  end

  def update(item)
    item.save
  end
end
