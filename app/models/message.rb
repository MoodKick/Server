class Message < ActiveRecord::Base
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :text, presence: true

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  def self.for_last_day
    max_date = maximum('created_on')
    where('created_on >= ?', max_date)
  end
end
