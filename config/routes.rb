Rails.application.routes.draw do
  resources :albums

  root to: 'albums#index'

  devise_for :users

  get '/search', to: 'albums#search', as: 'search'

  get '/artists', to: 'albums#artists', as: 'artists'

  post '/rate/:id', to: 'rate#create', as: 'rate'
end
