class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :username, :full_name, :avatar_url, :location, :description

  validates :username, :full_name, presence: true
  validates :username, uniqueness: true
  validates :location, presence: true

  has_many :contacts, foreign_key: :owner_id
  has_many :daily_journals, foreign_key: :user_id
  belongs_to :primary_therapist, class_name: 'User'

  #FIXME: autoload Role, so that it can be deserialized
  Role
  serialize :roles

  def self.excluding(user_id)
    where("id != ?", user_id)
  end

  def self.by_authentication_token(token)
    where(authentication_token: token).first
  end

  def self.by_username(username)
    where(username: username).first
  end

  def messages
    t = Message.arel_table

    Message.where(t[:sender_id].eq(self.id).or(t[:receiver_id].eq(self.id))).includes(:sender).includes(:receiver)
  end

  def has_contact?(user)
    contacts.map(&:user_id).include?(user.id)
  end

  def ability
    Ability.new(self)
  end

  def authorize!(*args)
    ability.authorize!(*args)
  end

  def add_daily_journal_entry(daily_journal_entry)
    self.daily_journals << daily_journal_entry
  end

  def daily_journal_entries
    daily_journals
  end

  def daily_journal_entries_for_last_n_days(n_days)
    daily_journals.where('created_at > ?', n_days.days.ago).all
  end

  def daily_journal_entry_by_id(daily_journal_entry_id)
    daily_journals.find(daily_journal_entry_id)
  end

  def daily_journal_entries_sorted_by_created_at
    daily_journals.order(:created_at).all
  end

  def make_primary_therapist(therapist)
    self.primary_therapist = therapist
  end

  #Roles
  def add_role(role)
    self.roles = self.roles + [role]
  end

  def remove_role(role)
    self.roles = self.roles - [role]
  end

  def has_role?(role)
    self.roles.include?(role)
  end

  def roles
    read_attribute(:roles) || []
  end

  #Therapist-specific staff:
  has_many :clients, class_name: 'User', foreign_key: 'primary_therapist_id'

  def add_client(client)
    self.clients << client
  end

  def client_by_id(client_id)
    clients.find(client_id)
  end
end
