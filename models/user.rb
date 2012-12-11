class User
  include MongoMapper::Document

  # key <name>, <type>
  key :nick, String
  key :password, String
  key :email, String
  key :is_admin, Boolean
  key :is_maintainer, Boolean
  key :is_tester, Boolean
  timestamps!
end
