class Post < ActiveRecord::Base
  has_ancestry cache_depth: true
  validates :body, presence: true
end
