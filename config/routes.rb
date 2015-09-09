Rails.application.routes.draw do

  # Routes for Subtreddits
  resources :subtreddits,  only: [:index, :show, :new, :create]

  # Routes for Devise Users - login/signup etc.
  devise_for :users

  # Routes for Posts
  resources :posts, except: [:edit, :destroy]

  # Makes root path 'front page' or Posts#index
  root 'posts#index'

  # Route to create a child Post (or comment) of a Post
  post 'comments/:id', to: 'posts#create_comment', as: 'post_comment'

  # Endpoint to add an upvote to a post
  put 'post/:id/upvote', to: 'posts#upvote', as: 'upvote_post'

  # Endpoint to undo an upvote
  delete 'post/:id/upvote', to: 'posts#destroy_upvote', as: 'destroy_upvote'

  # Pretty URL to display all the posts in a Subtreddit.
  get 'tr/:name', to: 'subtreddits#show', as: 'pretty_subtreddit'
end
