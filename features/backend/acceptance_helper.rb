require_relative '../acceptance_helper'

def sign_in_admin!(admin)
  sign_in_user!(admin)
end

def sign_in_client!(client)
  sign_in_user!(client)
end

def sign_in_therapist!(therapist)
  sign_in_user!(therapist)
end

def sign_in_user!(user)
  visit '/backend/users/sign_in'
  fill_in 'Username', with: user.username
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
