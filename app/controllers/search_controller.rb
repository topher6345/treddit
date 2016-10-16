class SearchController < ApplicationController
  def index
    @query = params[:q]
  end
end
