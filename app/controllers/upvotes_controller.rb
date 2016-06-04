# = Upvoteable
#
# This class defines actions to add/remove upvotes to Posts.

class UpvotesController < ApplicationController

  # Sets an instance variable to interact with an existing Post record.
  before_action :set_post, except: [:index]

  # Redirects to login page if no User session exists.
  before_action :authenticate_user!, except: [:index]

  def index
    if user_signed_in?
      upvotes = current_user.votes.pluck(:post_id)
      render json: { votes: upvotes }.to_json, status: 200
    else
      render json: { votes: [] }.to_json, status: 304
    end
  end

  # Defines an endpoint to add an upvote to an existing Post.
  def create
    Upvote.create! user: current_user, post: @post\
      unless Vote.where(user: current_user, post: @post).exists?

    @post.root.touch
    render json: { status: :ok }, status: :ok
  end

  # Defines an endpoint to undo an existing upvote to an existing Post.
  def destroy
    Upvote.destroy_all! user: current_user, post: @post
    render json: { status: :ok }, status: :ok
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
end
