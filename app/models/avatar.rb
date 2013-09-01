# Image avatar with predefined values
class Avatar
  attr_reader :id, :url

  def self.all
    [
      Avatar.new(1, 'http://dev.moodkick.com/images/avatars/avatar-01-large.png'),
      Avatar.new(2, 'http://dev.moodkick.com/images/avatars/avatar-02-large.png'),
      Avatar.new(3, 'http://dev.moodkick.com/images/avatars/avatar-03-large.png'),
      Avatar.new(4, 'http://dev.moodkick.com/images/avatars/avatar-04-large.png'),
    ]
  end

  def initialize(id, url)
    @id = id
    @url = url
  end
end
