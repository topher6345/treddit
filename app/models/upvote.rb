# Creation class to update both the Post's cached vote count
# and create a vote linking a user and a post.
#
# There are two class methods that serve as the public API
#
#   # User upvotes a post
#   Upvote.create! user: user, post: post
#
#   # User removes an upvote from a post
#   Upvote.destroy! user: user, post: post
#
class DuplicateUpvote < StandardError; end
class UpvoteNotFound < StandardError; end

class Upvote
  def self.create!(user:, post:)
    new(user: user, post: post).create_vote.increment_post_votes
  end

  def self.destroy!(user:, post:)
    new(user: user, post: post).destroy_vote.decrement_post_votes
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
    @post.increment(:votes)
    @post.save!
    self
  end

  def destroy_vote
    fail UpvoteNotFound unless Vote.exists?(user: @user, post: @post)
    Vote.find_by(user: @user, post: @post).destroy!
    self
  end

  def decrement_post_votes
    @post.decrement(:votes)
    @post.save!
    self
  end
end


