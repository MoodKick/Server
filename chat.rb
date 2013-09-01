require 'em-websocket'
require_relative 'config/environment'

class Client
  attr_accessor :websocket
  attr_accessor :user
  attr_accessor :registered_user

  def initialize(websocket_arg)
    @websocket = websocket_arg
  end
end

class ChatRoom
  def initialize
    @clients = {}
    @registered_users = {}
  end

  def start(opts={})
    puts "Started"
    EventMachine::WebSocket.start(opts) do |websocket|
      websocket.onopen    { add_client(websocket) }
      websocket.onmessage { |data| handle_message(websocket, data) }
      websocket.onclose   { remove_client(websocket) }
    end
  end

  def add_client(websocket)
    client = Client.new(websocket)
    @clients[websocket] = client
  end

  def remove_client(websocket)
    puts "remove client"
    client_to_remove = @clients[websocket]
    if client_to_remove.user # may not be so, if not registered user connects
      client_to_remove.user.online = false
      client_to_remove.user.save
      #TODO notify only clients, who have user in contacts
      @registered_users.delete(client_to_remove.user.username)
      @registered_users.each do |username, client|
        client.websocket.send("{\"type\": \"went_offline\", \"user_id\": \"#{client_to_remove.user.id}\"}")
      end
    end
    @clients.delete(websocket)
  end

  def handle_message(websocket, raw_data)
    data = JSON.parse(raw_data)
    message_type = data['type']
    if message_type == 'register_user'
      register_user(websocket, data)
    elsif message_type == 'send_message'
      send_message(data)
    end
  end

  def send_message(data)
    #TODO: don't send messages to users, who don't have senders in contacts
    puts "send message #{data.inspect}"
    receiver = @registered_users[data['to']]
    message = data['message']
    message.gsub!(/'/, '')
    if receiver
      socket_message = {}
      socket_message["type"] = "received_message"
      socket_message["from"] = sender(data).username
      socket_message["message"] = message
      receiver.websocket.send(socket_message.to_json)
    end
    receiver_user = if receiver
      receiver.user
    else
      User.by_username(data['to'])
    end
    Message.create(sender_id: sender(data).id, receiver_id: receiver_user.id, text: data['message'])
  rescue Exception => e
    puts e
  end

  def sender(data)
    User.by_authentication_token(data['auth_token'])
  end

  def register_user(websocket, data)
    user = User.by_authentication_token(data['auth_token'])
    #TODO: what shall happen if not found user is trying to authenticate?
    return unless user
    client = @clients[websocket]
    client.user = user
    @registered_users[user.username] = client
    client.registered_user = @registered_users[user.username]
    user.online = true
    user.save
    @registered_users.each do |username, client|
      client.websocket.send("{\"type\": \"went_online\", \"user_id\": \"#{user.id}\"}")
    end
  end
end

chatroom = ChatRoom.new
chatroom.start(host: '0.0.0.0', port: 8080, debug: true)
