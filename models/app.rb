class App
  include MongoMapper::Document
  attr_accessor :author_password, :author_password_confirmation

  # key <name>, <type>
  key :app_id, String
  key :author_email, String
  key :author_crypted_password, String
  key :name, String
  key :description, String
  key :dependencies, Array
  key :maintainers, Array
  key :git_url, String
  key :git_branch, String
  key :git_commit, String

  many :users, :in => :maintainers

  timestamps!

  validates_presence_of     :app_id
  validates_presence_of     :author_email
  validates_presence_of     :name
  validates_presence_of     :git_url
  validates_presence_of     :git_branch
  validates_presence_of     :git_commit
  validates_presence_of     :author_password,                      :if => :password_required
  validates_presence_of     :author_password_confirmation,         :if => :password_required
  validates_length_of       :author_password, :within => 4..400,   :if => :password_required
  validates_confirmation_of :author_password,                      :if => :password_required
  validates_length_of       :author_email,    :within => 3..100
  validates_uniqueness_of   :app_id,   :case_sensitive => false
  validates_format_of       :author_email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  def has_password?(author_password)
    ::BCrypt::Password.new(author_crypted_password) == author_password
  end

  private
  def encrypt_password
    self.author_crypted_password = ::BCrypt::Password.create(author_password)
  end

  def password_required
    author_crypted_password.blank? || author_password.present?
  end
end
