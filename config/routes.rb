Rails.application.routes.draw do
  root to: 'albums#index'

  devise_for :users
  resources :users
  resources :albums

  get 'search', to: 'albums#search'
  get 'stats(/:year)', to: 'albums#stats', as: 'stats'

  scope :api do
    get 'artists', to: 'albums#artists'
    get 'labels', to: 'albums#labels'
    post 'rate/:album_id', to: 'rates#create', as: 'rate'
  end
end
