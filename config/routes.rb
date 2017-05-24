Rails.application.routes.draw do
  root 'pages#landing'

  devise_for :users,
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: { registrations: 'users/registrations' }

  resources :users, only: [:index, :show, :update, :destroy]

  resources :albums do
    resources :comments, only: [:create, :update, :destroy]
    collection do
      get 'search'
      get 'stats(/:year)', to: 'albums#stats', as: 'stats'
    end
  end

  resources :lists do
    patch 'albums/:album_id', to: 'lists#move_album', as: 'move_album'
    delete 'albums/:album_id', to: 'lists#delete_album', as: 'delete_album'
  end

  scope :api do
    get 'artists', to: 'albums#artists'
    get 'labels', to: 'albums#labels'
    post 'rate/:album_id', to: 'rates#create', as: 'rate'
  end

  get 'robots.:format', to: 'pages#robots'
  get 'sitemap.xml.gz', to: 'pages#sitemap'
  get 'status', to: 'pages#status'
end
