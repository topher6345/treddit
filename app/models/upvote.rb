# = Upvote
#
# Upvote is a creation class encapsulating
# * create a vote linking a user and a post
# * update both the Post's cached vote count
#
# There are two class methods that serve as the public API.
#
# == create!
#
#   Upvote.create! user: user, post: post
#
# == destroy_all!
#
#   Upvote.destroy_all! user: user, post: post
#
# Either of these will throw an exception if the operation cannot be completed
#
class Upvote
  include ActiveModel::Validations
  attr_accessor :user, :post
  validates!    :user, :post, presence: true

  def self.create!(user:, post:)
    new(user: user, post: post).save!
  end

  def self.destroy_all!(user:, post:)
    new(user: user, post: post).destroy!
  end

  def initialize(attributes)
    @user = attributes[:user]
    @post = attributes[:post]
  end

  def save!
    ActiveRecord::Base.transaction do
      valid?
      create_vote
      increment_post_votes
    end

    @vote
  end

  def destroy!
    ActiveRecord::Base.transaction do
      valid?
      destroy_vote
      decrement_post_votes
    end

    true
  end

  def create_vote
    fail DuplicateUpvote if Vote.exists?(user: @user, post: @post)
    @vote = Vote.create! user: @user, post: @post
  end

  def increment_post_votes
    @post.increment(:votes)
    @post.save!
  end

  def destroy_vote
    fail UpvoteNotFound unless Vote.exists?(user: @user, post: @post)
    Vote.find_by(user: @user, post: @post).destroy!
  end

  def decrement_post_votes
    @post.decrement(:votes)
    @post.save!
  end
end

# == Upvote Exception classes
#
# Raised when someone tries to upvote twice
# Enforced by database index in `votes table.
class DuplicateUpvote < StandardError; end

# Raise when one tries to undo an upvote that doesn't exist
class UpvoteNotFound < StandardError; end
