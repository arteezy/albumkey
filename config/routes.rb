Rails.application.routes.draw do
  resources :albums

  root to: 'albums#index'

  devise_for :users

  resources :articles#, :constraints => { :id => /[^\/]+/ }

  get '/top/:year', to: 'top#index', as: 'top'

  post '/rate/:id', to: 'rate#create', as: 'rate'
end
