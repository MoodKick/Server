# manage content objects
class ContentObjectService
  def initialize(repository, scanner, path)
    @repository = repository
    @scanner = scanner
    @path = path
  end

  # udpate all content objects using scanner
  def update_all(subscriber)
    content_object_attributes = scanner.scan(path)
    repository.update_all_with(content_object_attributes)
    subscriber.success
  end

  # list all content objects
  def list(subscriber)
    subscriber.success(repository.all)
  end

  # get content object by id
  def show(id, subscriber)
    subscriber.success(repository.find(id))
  end

  # increase launch number for content object by id
  def launched(id, subscriber)
    repository.increase_launch_number(id)
  end

  private
    attr_reader :repository, :scanner, :path
end
