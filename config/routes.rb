Rails.application.routes.draw do
  resources :albums

  root to: 'albums#index'

  devise_for :users

  get '/search', to: 'albums#search', as: 'search'

  post '/rate/:id', to: 'rate#create', as: 'rate'
end
