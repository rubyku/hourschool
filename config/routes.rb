HourschoolV2::Application.routes.draw do

  resources :subscription_charges

  resources :dashboards

  resources :invites

  resources :missions do
    resources :topics
    resources :courses
    resources :crewmanships do
    end
  end

  resources :pre_mission_signups

  resources :tracks
  resources :flowcharts

  resources :cities, :only => [:index]

  # temp hack, remove after Febuary 2011
  match "/confirm" => redirect {|params, response| "/courses/#{response.query_parameters[:id]}/confirm" }

  namespace :users do
    resources :ticket_invite
    resources :settings
    namespace :facebook do
      resources :share
    end
  end

  scope :path => '/admin', :module => 'admin', :as => 'admin' do
    resources :courses
    resources :users
    resources :payments
    resources :metrics
    resources :trends
    resources :settings
  end

  resources :admin

  resources :comments

  resources :accounts do
    resources :users
    resources :memberships do
    end
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
  match 'user_root' => 'dashboards#index'
  resources :users do
    resources :followings
    member do
      put 'make_admin'
      put 'update_card'
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

  match '/errand'                     => 'admin#show',        :id => 'errand'

  match '/home'                    => 'accounts#show'
  match '/members'                    => 'users#index'
  match '/classes'                    => 'Courses::Browse#index'
  match '/blog'                       => 'comments#index'

  match '/preview/:id'                => 'courses#preview', :as => 'preview'
  match '/confirm/:id'                => 'courses#confirm', :as => 'confirm'

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

  match '/about-subnav'               => 'pages#show', :id => 'about-subnav'

  match '/business'                   => 'pages#show', :id => 'business'
  match '/store'                      => 'pages#show', :id => 'store'
  match '/about'                      => 'pages#show', :id => 'about'
  match '/team'                       => 'pages#show', :id => 'team'
  match '/story'                      => 'pages#show', :id => 'story'
  match '/events'                     => 'pages#show', :id => 'events'
  match '/resources'                  => 'pages#show', :id => 'resources'
  match '/campaign'                   => 'pages#show', :id => 'campaign'
  match '/communities'                => 'pages#show', :id => 'communities'
  match '/teach'                      => 'pages#show', :id => 'teach'
  match '/build_mission'              => 'pages#show', :id => 'build_mission'
  match '/build_school'               => 'pages#show', :id => 'build_school'
  match '/wall_of_awesome'            => 'pages#show', :id => 'wall_of_awesome'
  match '/wall_of_missions'           => 'pages#show', :id => 'wall_of_missions'
  match '/pro'                        => 'pages#show', :id => 'pro'

  match '/f4d_community'              => 'pages#show', :id => 'feastfordays/community'
  match '/f4d_host'                   => 'pages#show', :id => 'feastfordays/host'
  match '/f4d_how_it_works'           => 'pages#show', :id => 'feastfordays/how_it_works'
  match '/f4d_about'                  => 'pages#show', :id => 'feastfordays/about'
  match '/f4d_faq'                    => 'pages#show', :id => 'feastfordays/faq'
  match '/f4d_terms_and_conditions'   => 'pages#show', :id => 'feastfordays/terms_and_conditions'
  match '/f4d_past_feasts'            => 'pages#show', :id => 'feastfordays/past_feasts'

  match '/learn'                      => 'pages#index'
  match '/epic'                       => 'pages#index'

  # post 'courses/:id/duplicate'        => 'courses#duplicate', :as => 'duplicate_course'


  root :to                            => "pages#index"

  match '/404'                        => 'errors#not_found'
  match '/500'                        => 'errors#error'


  match 'sitemap/'                    => redirect('https://s3.amazonaws.com/hourschool-sitemap/sitemaps/sitemap_index.xml.gz')

  resources :test



  if Rails.env.development?
    ["UserMailer", "StudentMailer"].each do |klass|
      mount "#{klass.gsub('::', '')}::Preview".constantize => "mail_view/#{klass.underscore}/preview"
    end
  end

end

