Rails.application.routes.draw do
  root 'albums#index'

  devise_for :users,
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
    controllers: { registrations: 'users/registrations' }

  resources :users

  resources :albums do
    resources :comments, only: [:create, :update, :destroy]
  end

  get 'search', to: 'albums#search'
  get 'stats(/:year)', to: 'albums#stats', as: 'stats'

  scope :api do
    get 'artists', to: 'albums#artists'
    get 'labels', to: 'albums#labels'
    post 'rate/:album_id', to: 'rates#create', as: 'rate'
  end

  get '/robots.:format', to: 'pages#robots'
  get '/sitemap.xml.gz', to: 'pages#sitemap'
end
