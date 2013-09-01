# repository for content objects
class ContentObjectRepository

  # update all content objects preserving their ids
  # all the content objects which do not get representation
  # in attributes_collection get deleted
  def update_all_with(attributes_collection)
    existing = all

    attributes_collection.each do |attributes|
      if found = existing.detect { |c| c.name == attributes['name'] }
        existing.delete(found)
        found.type = attributes['type']
        found.title = attributes['title']
        found.data = attributes['data']
        found.author = attributes['author']
        found.description = attributes['description']
        found.save
      else
        add_from_attributes(attributes)
      end
    end
    existing.each { |cob| cob.delete }
  end

  # increase launch number for content object identified by id
  def increase_launch_number(id)
    content_object = find(id)
    content_object.launch_number += 1
    content_object.save
  end

  def delete_all
    ContentObject.delete_all
  end

  # all content objects ordered by created_at
  def all
    ContentObject.order(:created_at).all
  end

  def add(content_object)
    content_object.save
  end

  # persist content object with attributes
  def add_from_attributes(attributes)
    content_object = ContentObject.new
    content_object.type   = attributes['type']
    content_object.name   = attributes['name']
    content_object.title  = attributes['title']
    content_object.data   = attributes['data']
    content_object.author = attributes['author']
    content_object.description = attributes['description']
    content_object.save
    content_object
  end

  # number of items in the collection
  def size
    ContentObject.count
  end

  def find(id)
    ContentObject.find(id)
  end
end
