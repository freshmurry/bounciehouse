Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # ROOT ROUTE
  root "pages#home"

  # STATIC PAGES
  get 'about', to: 'pages#about'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'faq', to: 'pages#faq'
  get 'blog', to: 'pages#blog'
  get 'careers', to: 'pages#careers'
  get 'support', to: 'pages#support'

  # DEVISE ROUTES FOR USER AUTHENTICATION
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration' },
             controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  # OMNIAUTH AND SESSION MANAGEMENT
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy'

  # USER RESOURCES WITH PHONE NUMBER MANAGEMENT
  resources :users, only: [:show] do
    member do
      post '/verify_phone_number', to: 'users#verify_phone_number'
      patch '/update_phone_number', to: 'users#update_phone_number'
    end
  end

  # BOUNCEHOUSES MANAGEMENT
  resources :bouncehouses do
    member do
      get 'photo_upload'
      get 'preload_reservations'
      get 'preview_reservations'
    end

    # RESERVATIONS AND RELATED ACTIONS
    resources :reservations, only: [:create] do
      collection do
        get 'preload', to: 'reservations#preload'
        get 'preview', to: 'reservations#preview'
      end

      member do
        post 'approve', to: "reservations#approve"
        post 'decline', to: "reservations#decline"
      end
    end

    resources :photos, only: [:create, :destroy]
    resources :calendars
    resources :guest_reviews, only: [:create, :destroy]
  end

  # HOST REVIEWS
  resources :host_reviews, only: [:create, :destroy]

  # RESERVATIONS ROUTES FOR SPECIFIC USER ACTIONS
  get '/previous_reservations', to: 'reservations#previous_reservations'
  get '/current_reservations', to: 'reservations#current_reservations'

  # DASHBOARD
  get 'dashboard', to: 'dashboards#index'

  # REVENUE MANAGEMENT
  resources :revenues, only: [:index]

  # CONVERSATIONS AND MESSAGES
  resources :conversations, only: [:index, :create, :destroy] do
    resources :messages, only: [:index, :create, :destroy]
  end

  # USER SETTINGS AND NOTIFICATIONS
  get '/host_calendar', to: 'calendars#host'
  get '/payment_method', to: 'users#payment'
  get '/payout_method', to: 'users#payout'
  post '/add_card', to: 'users#add_card'

  get '/notification_settings', to: 'settings#edit'
  post '/notification_settings', to: 'settings#update'
  delete '/notification_settings', to: 'settings#destroy'

  get '/notifications', to: 'notifications#index'

  # ACTION CABLE
  mount ActionCable.server => '/cable'
end
