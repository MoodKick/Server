PATH = "/Users/andrewshcheglov/Ruby/moodkick-server-backend"
God.watch do |w|
  w.name = "chat"
  w.start = "cd #{PATH}; bundle exec ruby chat.rb"
  w.log = "/Users/andrewshcheglov/Ruby/moodkick-server-backend/log/chat.log"
  w.keepalive
end
