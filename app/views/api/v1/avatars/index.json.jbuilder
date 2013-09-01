json.array! @avatars do |json, avatar|
  json.id avatar.id
  json.url avatar.url
end
