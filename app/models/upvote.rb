# Creation class to update both the Post's cached vote count
# and create a vote linking a user and a post.

class Upvote
  attr_reader :post
  def self.create!(user:, post:)
    new(user: user, post: post).create_vote.increment_post_votes
  end

  def initialize(user:, post:)
    @user = user
    @post = post
  end

  def create_vote
    fail DuplicateUpvote if Vote.exists?(user: @user, post: @post)
    Vote.create! user: @user, post: @post
    self
  end

  def increment_post_votes
    @post.votes += 1
    @post.save!
    self
  end
end

class DuplicateUpvote < StandardError; end