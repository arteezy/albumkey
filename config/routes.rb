Rails.application.routes.draw do
  resources :albums
  root to: 'albums#index'
  devise_for :users
  get '/search', to: 'albums#search'

  scope :api do
    get '/artists', to: 'albums#artists'
    get '/labels', to: 'albums#labels'
    post '/rate/:id', to: 'rates#create', as: 'rate'
  end
end
