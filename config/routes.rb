Rails.application.routes.draw do

  # Makes root path 'front page' or Posts#index
  root 'posts#index'

  # Pretty URL to display all the posts in a Subtreddit.
  get 'tr/:name', to: 'subtreddits#show', as: 'pretty_subtreddit'

  # Routes for Posts
  resources :posts, except: [:edit, :destroy] do

    # Route to create a child Post (or comment) of a Post
    resource :comments, only: [:create], as: 'comment'

    # Endpoint to add an upvote to a post
    resource :upvotes, only: [:create, :destroy]
  end

  # Routes for Devise Users - login/signup etc.
  devise_for :users

  # Routes for Subtreddits
  resources :subtreddits,  only: [:index, :show, :new, :create]

end
