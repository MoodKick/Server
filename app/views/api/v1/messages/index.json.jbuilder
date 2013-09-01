json.array! @messages do |json, message|
  json.id message.id
  json.sender message.sender.username
  json.receiver message.receiver.username
  json.text message.text
  json.created_at message.created_at
  json.created_on message.created_on
end
