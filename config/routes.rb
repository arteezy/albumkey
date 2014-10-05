Richfork::Application.routes.draw do
  root to: 'articles#index'

  devise_for :users

  resources :articles#, :constraints => { :id => /[^\/]+/ }

  get '/top/:year', to: 'top#index', as: 'top'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'articles/score/:score' => 'articles#score'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
