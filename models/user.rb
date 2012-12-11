class User
  include MongoMapper::Document
  attr_accessor :password, :password_confirmation

  # key <name>, <type>
  key :nick, String
  key :crypted_password, String
  key :email, String
  key :role, String
  timestamps!

  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_uniqueness_of   :nick,     :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :nick,     :with => /\w/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(nick, password)
    account = first(:nick => nick) if nick.present?
    account && account.has_password?(password) && account.role == 'admin' ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password)
  end

  def password_required
    crypted_password.blank? || password.present?
  end
end
