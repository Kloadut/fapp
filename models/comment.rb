class Comment
  include MongoMapper::Document

  # key <name>, <type>
  key :id, Integer
  key :app_id, String
  key :nick, String
  key :body, String
  timestamps!
end
