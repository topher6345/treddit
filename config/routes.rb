Rails.application.routes.draw do

  get 'search', to: 'search#index'

  get 'stream/index'

  # Makes root path 'front page' or Posts#index
  root 'posts#index'

  # Pretty URL to display all the posts in a Subtreddit.
  get 'tr/:name', to: 'subtreddits#show', as: 'pretty_subtreddit'

  get 'upvotes', to: 'upvotes#index', as: 'upvotes'

  # Routes for Posts
  resources :posts, except: [:edit, :destroy] do

    # Route to create a child Post (or comment) of a Post
    resource :comments, only: [:create, :new], as: 'comment'

    # Endpoint to add an upvote to a post
    resource :upvotes, except: [:index]
  end

  # Routes for Devise Users - login/signup etc.
  devise_for :users

  # Routes for Subtreddits
  resources :subtreddits,  only: [:index, :show, :new, :create]

end
