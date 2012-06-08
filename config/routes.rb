HourschoolV2::Application.routes.draw do



  resources :tracks

  resources :cities, :only => [:index]

  # temp hack, remove after Febuary 2011
  match "/confirm" => redirect {|params, response| "/courses/#{response.query_parameters[:id]}/confirm" }

  namespace :users do
    namespace :facebook do
      resources :share
    end
  end

  scope :path => '/admin', :module => 'admin', :as => 'admin' do
    resources :charts
    namespace :charts do
      resources :months
    end
  end

  resources :comments

  resources :suggestions do
    resources :nominations, :module => "suggestions"
  end


  namespace :courses do
    resources :browse
    resources :search
    resources :series, :except => :create
  end

  namespace :payments do
    namespace :paypal do
      resources :requests,  :only => [:new, :create]
      resources :responses, :only => [:create]
    end
  end

  match '/payments/paypal/responses' => 'Payments::Paypal::Responses#create'

  resources :courses do
    resources :owner,     :controller => 'courses/owner'
    resource  :duplicate, :controller => 'courses/duplicate'
    resources :series,    :controller => 'courses/series', :only => :create
  end

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
    end
  end

  ActiveAdmin.routes(self)

  scope :module => 'users' do
    resources :after_register, :only => [:show, :update]
  end

  resources :payments
  resources :accounts

  match 'confirm_payment'             => 'payments#confirm'


  match 'oh-no/404'                   => 'pages#show',        :id => 'errors/404'
  match 'oh-no/500'                   => 'pages#show',        :id => 'errors/404'

  match '/learn'                      => 'Courses::Browse#index'
  match '/suggest'                    => 'suggestions#suggest'
  match '/csvote'                     => 'suggestions#vote'
  match '/register'                   => 'courses#register'
  match '/drop'                       => 'courses#drop'
  match '/preview/:id'                => 'courses#preview', :as => 'preview'
  match '/confirm/:id'                => 'courses#confirm', :as => 'confirm'
  match '/payment_preview'            => 'courses#register_preview'
  
  match '/courses'                    => 'Courses::Admin#index'

  match '/proposal'                   => 'courses/admin#show_proposal'
  match '/approve'                    => 'courses#approve'

  match '/courses-proposals'          => 'courses/admin#proposals', :as => 'course_proposals'
  match '/courses-pending-live'       => 'courses/admin#pending_live', :as => 'course_pending_live'

  match '/users-table'                => 'users#table'

  match '/community'                  => 'home#community'
  match '/community_faq'              => 'home#community_faq'

  match '/profile'                    => 'users#show', :id => 'current'
  match '/profile_past_taught'        => 'users#profile_past_taught'
  match '/profile_past_attended'      => 'users#profile_past_attended'
  match '/profile-suggest'            => 'users#profile_suggest'
  match '/profile-pending'            => 'users#profile_pending'
  match '/profile-approved'           => 'users#profile_approved'

  match '/my_classes'                 => 'users#my_classes'
  match '/classes_taken'              => 'users#classes_taken'
  match '/classes_taught'             => 'users#classes_taught'

  match '/contact'                    => 'home#contactus'
  match '/search'                     => 'home#search'

  match '/search_by_tg'               => 'home#search_by_tg', :as => "tags"
  match '/organization'               => 'home#organization'
  match '/nominate'                   => 'home#nominate'
  match '/nominate_send'              => 'home#nominate_send'
  match '/nominate_confirm'           => 'home#nominate_confirm'
  match '/nominate_reject'            => 'home#nominate_reject'
  match '/nominate_reject_send'       => 'home#nominate_reject_send'
  match '/contact_teacher'            => 'courses#contact_teacher', :as => "contact_teacher"
  match '/contact_teacher_send'       => 'courses#contact_teacher_send'
  match '/contact_all_students'       => 'courses#contact_all_students'
  match '/contact_all_students_send'  => 'courses#contact_all_students_send'
  match '/feedback'                   => 'courses#feedback', :as => 'feedback'
  match '/feedback_send'              => 'courses#feedback_send'

  match '/business'                   => 'pages#show', :id => 'business'
  match '/about'                      => 'pages#show', :id => 'about'
  match '/team'                       => 'pages#show', :id => 'team'
  match '/story'                      => 'pages#show', :id => 'story'
  match '/campaign'                   => 'pages#show', :id => 'campaign'
  match '/teach'                      => 'pages#show', :id => 'teach'

  match '/start'                      => 'pages#index'

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

