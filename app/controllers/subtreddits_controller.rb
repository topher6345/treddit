class SubtredditsController < ApplicationController
  before_action :set_subtreddit, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:show]

  # GET /subtreddits
  # GET /subtreddits.json
  def index
    @subtreddits = Subtreddit.all
  end

  # GET /subtreddits/1
  # GET /subtreddits/1.json
  def show
  end

  # GET /subtreddits/new
  def new
    @subtreddit = Subtreddit.new
  end

  # GET /subtreddits/1/edit
  def edit
  end

  # POST /subtreddits
  # POST /subtreddits.json
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

  # PATCH/PUT /subtreddits/1
  # PATCH/PUT /subtreddits/1.json
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

  # DELETE /subtreddits/1
  # DELETE /subtreddits/1.json
  def destroy
    @subtreddit.destroy
    respond_to do |format|
      format.html { redirect_to subtreddits_url, notice: 'Subtreddit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subtreddit
      @subtreddit = Subtreddit.find_by(name: params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subtreddit_params
      params.require(:subtreddit).permit(:name, :description)
    end

    def set_posts
      @posts = @subtreddit.posts.where(ancestry_depth: 0)
    end
end
