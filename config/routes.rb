Rails.application.routes.draw do
  resources :albums

  root to: 'albums#index'

  devise_for :users

  resources :articles#, :constraints => { :id => /[^\/]+/ }

  get '/dash', to: 'albums#dash', as: 'dash'

  post '/rate/:id', to: 'rate#create', as: 'rate'
end
