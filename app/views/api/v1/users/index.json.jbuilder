json.array! @users do |json, user|
  json.id user.id
  json.username user.username
  json.email user.email
  json.full_name user.full_name
  json.avatar_url avatar_url(avatar_url(user.avatar_url))
  json.roles api_user_roles(user.roles)
  json.location user.location
  json.description user.description
  json.in_contacts @owner.has_contact?(user)
end
