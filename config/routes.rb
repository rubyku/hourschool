HourschoolV2::Application.routes.draw do

  resources :subscription_charges

  resources :dashboards

  resources :invites

  resources :missions do
    resources :topics
    resources :crewmanships do
    end
  end

  resources :pre_mission_signups

  resources :tracks

  resources :cities, :only => [:index]

  # temp hack, remove after Febuary 2011
  match "/confirm" => redirect {|params, response| "/courses/#{response.query_parameters[:id]}/confirm" }

  namespace :users do
    resources  :settings
    namespace :facebook do
      resources :share
    end
  end

  scope :path => '/admin', :module => 'admin', :as => 'admin' do
    resources :courses
    resources :metrics
  end

  resources :comments

  resources :suggestions do
    resources :nominations, :module => "suggestions"
  end


  namespace :courses do
    resources :browse
    resources :search

    # course_id is required
    resources :series, :except => :create
  end

  resources :courses
  resources :courses, :module => 'courses' do # courses/:course_id
    resources :organizer

    resource  :duplicate
    resources :feedback
    resources :series,   :only => :create 
    
    namespace :attendee do
      resources :contacts
      resources :registrations
    end

    namespace :organizer do
      resources :contacts
    end
  end

  namespace :payments do
    namespace :paypal do
      resources :requests,  :only => [:new, :create]
      resources :responses, :only => [:create]
    end
  end

  match '/payments/paypal/responses' => 'Payments::Paypal::Responses#create'



  devise_for :users, :controllers => { :omniauth_callbacks  => "users/omniauth_callbacks",
                                       :registrations       => "registrations",
                                       :sessions            => 'sessions' }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  match 'user_root' => 'pages#index'
  resources :users do
    resources :followings
    member do
      put 'make_admin'
    end
    collection do
      get 'new_invite'
      post 'send_invite'
      get :search
    end
  end

  scope :module => 'users' do
    resources :after_register, :only => [:show, :update]
  end

  resources :payments
  resources :accounts

  match 'confirm_payment'             => 'payments#confirm'


  match 'oh-no/404'                   => 'pages#show',        :id => 'errors/404'
  match 'oh-no/500'                   => 'pages#show',        :id => 'errors/404'

  match '/explore'                      => 'Courses::Browse#index'
  match '/suggest'                    => 'suggestions#suggest'
  match '/csvote'                     => 'suggestions#vote'

  match '/preview/:id'                => 'courses#preview', :as => 'preview'
  
  match '/courses'                    => 'Courses::Admin#index'

  match '/proposal'                   => 'courses/admin#show_proposal'
  match '/approve'                    => 'courses#approve'

  match '/users-table'                => 'users#table'

  match '/profile'                    => 'users#show', :id => 'current'
  match '/profile_past_taught'        => 'users#profile_past_taught'
  match '/profile_past_attended'      => 'users#profile_past_attended'
  match '/profile-suggest'            => 'users#profile_suggest'
  match '/profile-pending'            => 'users#profile_pending'
  match '/profile-approved'           => 'users#profile_approved'

  match '/my_classes'                 => 'users#my_classes'
  match '/classes_taken'              => 'users#classes_taken'
  match '/classes_taught'             => 'users#classes_taught'

  match '/nominate'                   => 'home#nominate'
  match '/nominate_send'              => 'home#nominate_send'
  match '/nominate_confirm'           => 'home#nominate_confirm'
  match '/nominate_reject'            => 'home#nominate_reject'
  match '/nominate_reject_send'       => 'home#nominate_reject_send'
  

  match '/business'                   => 'pages#show', :id => 'business'
  match '/about'                      => 'pages#show', :id => 'about'
  match '/team'                       => 'pages#show', :id => 'team'
  match '/story'                      => 'pages#show', :id => 'story'
  match '/campaign'                   => 'pages#show', :id => 'campaign'
  match '/teach'                      => 'pages#show', :id => 'teach'
  match '/build_mission'              => 'pages#show', :id => 'build_mission'
  match '/build_school'               => 'pages#show', :id => 'build_school'
  match '/wall_of_awesome'            => 'pages#show', :id => 'wall_of_awesome'
  match '/wall_of_missions'           => 'pages#show', :id => 'wall_of_missions'
  match '/partner_schools'           => 'pages#show', :id => 'partner_schools'

  match '/start'                      => 'pages#index'
  match '/learn'                      => 'pages#index'

  # post 'courses/:id/duplicate'        => 'courses#duplicate', :as => 'duplicate_course'


  root :to                            => "pages#index"

  match '/404'                        => 'errors#not_found'
  match '/500'                        => 'errors#error'


  match 'sitemap/'                    => redirect('https://s3.amazonaws.com/hourschool-sitemap/sitemaps/sitemap_index.xml.gz')

  resources :test

  if Rails.env.development?
    mount StudentMailer::Preview => 'mail_view'
  end

end

