# = SubtredditsController
#
# This class defines actions to interact with the Subtreddit record.
#
# A Subtreddit is like a Reddit Subtreddit.
#
# The SubtredditsController#show action is unique in that it displays
# a list of Posts to the end-user.
#
# Other actions will be provided in the future to created and update Subtreddits.

class SubtredditsController < ApplicationController

  # Sets @subtreddit instance variable found by subtreddit name
  before_action :set_subtreddit, only: [:show, :edit]

  # Sets @post instance variable found by subtreddit
  before_action :set_posts, only: [:show]

  # Requires a user to be logged in to manipulate Subtreddit record.
  before_action :authenticate_user!, only: [:new, :create]

  # Displays a list of all Subtreddits in Treddit.
  def index
    @subtreddits = Subtreddit.all
  end

  # Displays the top Posts of a particular subtreddit accessed by name
  #
  #    http://treddit.com/tr/:name
  #
  def show
  end

  # Displays a form to create a new Subtreddit.
  def new
    @subtreddit = Subtreddit.new
  end

  # TODO : add route and views for Subtreddit edit.
  # No route exists for this action yet.
  # Theres no user-edits-a-subtreddit feature yet.
  def edit
  end

  # Defines an endpoint to create a new Subtreddit.
  def create
    @subtreddit = Subtreddit.new(subtreddit_params)

    respond_to do |format|
      if @subtreddit.save
        format.html { redirect_to @subtreddit, notice: 'Subtreddit was successfully created.' }
        format.json { render :show, status: :created, location: @subtreddit }
      else
        format.html { render :new }
        format.json { render json: @subtreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO : add route for Subtreddit update.
  # No route exists for this action yet.
  # Theres no user-edits-a-subtreddit feature yet.
  def update
    respond_to do |format|
      if @subtreddit.update(subtreddit_params)
        format.html { redirect_to @subtreddit, notice: 'Subtreddit was successfully updated.' }
        format.json { render :show, status: :ok, location: @subtreddit }
      else
        format.html { render :edit }
        format.json { render json: @subtreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO : add route for Subtreddit destroy.
  # No route exists for this action yet.
  # Theres no user-deletes-a-subtreddit feature yet.
  def destroy
    @subtreddit.destroy
    respond_to do |format|
      format.html { redirect_to subtreddits_url, notice: 'Subtreddit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Finds a Subtreddit by name in URL. Ex: `tr/:name`
    def set_subtreddit
      @subtreddit = Subtreddit.find_by(name: params[:name])
    end

    # Defines whitelisted parameters used to create a new Subtreddit.
    def subtreddit_params
      params.require(:subtreddit).permit(:name, :description)
    end

    # Finds all Posts for a Subtreddit.
    def set_posts
      @posts = @subtreddit.posts.where(ancestry_depth: 0)
    end
end
