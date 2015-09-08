# = PostController
#
# This class defines actions to directly interact with Post records.

class PostsController < ApplicationController
  # Add behavior to create a child post, or comment to another (parent) Post
  include Commentable

  # Add behavior to `upvote` a post.
  include Upvoteable

  # Sets an instance variable to interact with an existing Post record.
  before_action :set_post, only: [ :edit, :update, :destroy]

  # Redirects to login page if no User session exists.
  before_action :authenticate_user!, only: [:new, :create, :create_comment, :upvote]

  # Displays all the root level Posts.
  # Serves as the 'Front Page' endpoint.
  def index
    @posts = Post.where(ancestry_depth: 0).includes(:user, :subtreddit).order(descendants_depth: :desc)
  end

  # Displays a Post and its descendants
  def show
    @parent = Post.find(params[:id])
    @posts = @parent.descendants.includes(:user).arrange(order: 'votes DESC')
  end

  # Displays a form for creating a new Post.
  def new
    @post = Post.new
  end

  # TODO : add route and views for Post edit.
  # No route exists for this action yet.
  # Theres no user-edits-a-post feature yet.
  def edit
  end

  # Creates a new post
  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  # TODO : Add endpoint for Post update.
  # No route exists for this action yet.
  # Theres no user-edits-a-post feature yet.
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
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

    # Whitelist of parameters that can be submitted to create a Post.
    def post_params
      params.require(:post).permit(:title, :body, :link, :subtreddit_id)
    end
end
