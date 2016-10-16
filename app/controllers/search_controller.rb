class SearchController < ApplicationController
  def index
    @query = params[:q]
    @hits, @results = \
      if @query.present?
        search = Post.search { fulltext params[:q] }
        [search.hits, search.results]
      else
        [[], []]
      end
    @hitcount = @hits.try(:count)
  end
end
