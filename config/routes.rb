HourschoolV2::Application.routes.draw do

  resources :ecourses, :path => 'classes'

  resources :csuggestions, :path => 'requests'
  resources :esuggestions, :path => 'suggestions'

  resources :courses

  devise_for :members 
  resources :members, :only => [:index, :show]
  
  
   resources :enterprises, :only => [:index, :show]  do 
    resources :subdomains, :shallow => true
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  match 'user_root' => 'users#show'
  resources :users, :only => [:index, :show] 
  
  
  
  match '/' => 'home#index', :constraints => { :subdomain => 'www' }
  match '/' => 'sites#show', :constraints => { :subdomain => /.+/ }
  
  get "sites/show"
  match '/learn' => 'home#learn'
  match '/teach' => 'home#teach'
  match '/csvote' => 'csuggestions#vote'
  match '/register' => 'courses#register'

  match '/enterprise-learn' => 'enterprises#learn'
  match '/enterprise-teach' => 'enterprise#teach'
  match '/esvote' => 'esuggestions#vote'
  match '/eregister' => 'ecourses#register'
  
  match '/community' => 'home#community'
  match '/community_faq' => 'home#community_faq'
  match '/profile' => 'users#profile'
  match '/contact' => 'home#contactus'
  
  match '/search_by_tg' => 'home#search_by_tg'
  match '/organization' => 'home#organization'
  root :to => "home#index"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
