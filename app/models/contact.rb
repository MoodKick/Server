# contact of user as in address book
class Contact < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :user, class_name: 'User'

  validates :user_id, uniqueness: {
    scope: :owner_id,
    message: 'Contact already exists'
  }
end
