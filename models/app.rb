class App
  include MongoMapper::Document

  # key <name>, <type>
  key :app_id, String
  key :author_mail, String
  key :author_password, String
  key :name, String
  key :description, String
  key :dependencies, Array
  key :maintainer, String
  key :git_url, String
  key :git_branch, String
  key :git_commit, String
  timestamps!
end
