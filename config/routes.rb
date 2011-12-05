HourschoolV2::Application.routes.draw do

  resources :ecourses, :path => 'classes'

  resources :suggestions# , :path => 'requests'
  resources :esuggestions, :path => 'suggestions'

  resources :courses

  devise_for :members
  resources :members, :only => [:index, :show]


   resources :enterprises, :only => [:index, :show]  do
    resources :subdomains, :shallow => true
  end

  devise_for :users, :controllers => { :omniauth_callbacks  => "users/omniauth_callbacks", 
                                       :registrations       => "registrations",
                                       :sessions            => 'sessions' }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  match 'user_root' => 'home#index'
  resources :users, :only => [:index, :show]

  resources :payments
  match 'confirm_payment' => 'payments#confirm'

  # match '/' => 'home#index', :constraints => { :subdomain => 'www' }
  # match '/' => 'sites#show', :constraints => { :subdomain => /.+/ }

  get "sites/show"
  match '/learn' => 'home#learn'
  match '/teach' => 'home#teach'
  match '/suggest' => 'suggestions#suggest'
  match '/csvote' => 'suggestions#vote'
  match '/register' => 'courses#register'
  match '/register_with_amazon' => 'courses#register_with_amazon'
  match '/drop' => 'courses#drop'
  match '/preview' => 'courses#preview'
  match '/confirm' => 'courses#confirm'
  match '/heart' => 'courses#heart'
  match '/proposal' => 'courses#show_proposal'
  match '/payment_preview' => 'courses#register_preview'
  match '/course_confirm' => 'courses#course_confirm'

  match '/enterprise-learn' => 'enterprises#learn'
  match '/enterprise-teach' => 'enterprise#teach'
  match '/esvote' => 'esuggestions#vote'
  match '/eregister' => 'ecourses#register'

  match '/approve' => 'courses#approve'

  match '/community' => 'home#community'
  match '/community_faq' => 'home#community_faq'
  match '/profile' => 'users#profile'
  match '/profile_teaching' => 'users#profile_teaching'
  match '/profile_past_taught' => 'users#profile_past_taught'
  match '/profile_past_attended' => 'users#profile_past_attended'
  match '/profile-suggest' => 'users#profile_suggest'
  match '/profile-pending' => 'users#profile_pending'
  match '/profile-approved' => 'users#profile_approved'

  match '/my_classes' => 'users#my_classes'
  match '/classes_taken' => 'users#classes_taken'
  match '/classes_taught' => 'users#classes_taught'

  match '/contact' => 'home#contactus'
  match '/search' => 'home#search'

  match '/search_by_tg' => 'home#search_by_tg', :as => "tags"
  match '/search_by_city' => 'home#search_by_city', :as => "cities"
  match '/organization' => 'home#organization'
  match '/about_save' => 'home#about_save'
  match '/nominate' => 'home#nominate'
  match '/nominate_send' => 'home#nominate_send'
  match '/nominate_confirm' => 'home#nominate_confirm'
  match '/nominate_reject' => 'home#nominate_reject'
  match '/nominate_reject_send' => 'home#nominate_reject_send'
  match '/contact_teacher' => 'courses#contact_teacher'
  match '/contact_teacher_send' => 'courses#contact_teacher_send'
  match '/contact_all_students' => 'courses#contact_all_students'
  match '/contact_all_students_send' => 'courses#contact_all_students_send'

  match '/business' => 'home#business'
  match '/about' => 'home#about'
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
