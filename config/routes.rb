Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show] do
    member do
      post 'set_role'
    end
  end
  root :to => 'posts#index'
  resources :posts do
    resources :comments
  end
  get 'home/show_user'
  get 'home/banned'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
