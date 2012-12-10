class Request
  include MongoMapper::Document

  # key <name>, <type>
  key :app_id, String
  key :initial_repo, String
  key :target_repo, String
  key :git_url, String
  key :git_branch, String
  key :git_commit, String
  key :status, String
  key :treated_by, String
  timestamps!
end
