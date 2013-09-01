json.array! @contacts do |json, contact|
  json.id contact.id
  json.owner_id contact.owner_id
  json.user_id contact.user_id
  json.username contact.user.username
  json.email contact.user.email
  json.full_name contact.user.full_name
  json.online contact.user.online
  json.avatar_url avatar_url(contact.user.avatar_url)
  json.description contact.user.description
  json.location contact.user.location
  json.roles api_user_roles(contact.user.roles)
  json.user do |json|
    json.id contact.user_id
    json.username contact.user.username
    json.email contact.user.email
    json.full_name contact.user.full_name
    json.avatar_url avatar_url(contact.user.avatar_url)
    json.location contact.user.location
    json.roles api_user_roles(contact.user.roles)
    json.description contact.user.description
  end
end
