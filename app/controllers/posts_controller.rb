# = PostController
#
# This class defines actions to directly interact with Post records.

class PostsController < ApplicationController
  # Allow post to broadcast new posts
  include Broadcastable

  # Sets an instance variable to interact with an existing Post record.
  before_action :set_post, only: [:show, :update]

  # Sets an instance variable containing all the comments for a parent Post.
  before_action :set_comments, only: [:show]

  # Redirects to login page if no User session exists.
  before_action :authenticate_user!, only: [:new, :create, :create_comment, :upvote, :update]

  # Sets an instance variable with a list of post_ids the current user has upvoted
  before_action :set_user_votes, only: [:show]

  # Displays all the root level Posts.
  # Serves as the 'Front Page' endpoint.
  def index
    @posts = Post.where(ancestry_depth: 0).order(votes: :desc).limit(20)
  end

  # Displays a Post and its descendants
  def show
    @votes = @post.votes
  end

  # Displays a form for creating a new Post.
  def new
    @post = Post.new
    @subtreddits = Subtreddit.all
    @pre_selected = @subtreddits.find_by_name!(params[:subtreddit]).id \
      if params[:subtreddit]
  end

  # Creates a new post
  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @post.save
        broadcast_new_post @post

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to new_post_url }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates a post and marks the record as edited.
  def update
    if update_post
      render json: { status: :ok }
    else
      render json: { errors: @post.errors }, status: :unauthorized
    end
  end

  # No route exists for this action yet.
  # I'm debating about wether a user should be able to destroy a post.
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Assigns instance variable based on id of Post.
    def set_post
      @post = Post.find(params[:id])
    end

    # Assigns instance variable containing all the comments of a post
    def set_comments
      @comments = @post.comments
    end

    # Whitelists parameters that can be submitted to create a Post.
    def post_params
      params.require(:post).permit(:title, :body, :link, :subtreddit_id)
    end

    # Updates a Post if user is authorized to do so
    def update_post
      return false unless current_user.posts.include? @post
      @post.update(post_params.merge edited: true)
    end

    # Assigns instance variable of all posts on which a user has voted.
    def set_user_votes
      @user_votes = []
      @user_votes = current_user.votes.pluck(:post_id) if user_signed_in?
    end
end
