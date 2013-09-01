json.id @contact.id
json.owner_id @contact.owner_id
json.user_id @contact.user_id
json.username @contact.user.username
json.email @contact.user.email
json.full_name @contact.user.full_name
json.online @contact.user.online
json.user do |json|
  json.id @contact.user_id
  json.username @contact.user.username
  json.email @contact.user.email
  json.full_name @contact.user.full_name
end