Rails.application.routes.draw do
  # Root route
  root "pages#home"
  get 'about', to: 'pages#about'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'faq', to: 'pages#faq'
  get 'blog', to: 'pages#blog'
  get 'careers', to: 'pages#careers'
  get 'support', to: 'pages#support'

  # Devise routes for user authentication
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration' },
             controllers: { omniauth_callbacks: 'omniauth_callbacks', omniauth_providers: [:google_oauth2], registrations: 'registrations' }

  # OmniAuth and session management
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy'

  # User resources with phone number management
  resources :users, only: [:show] do
    member do
      post 'verify_phone_number'
      patch 'update_phone_number'
    end
  end

  # Bouncehouses management
  resources :bouncehouses do
    member do
      get 'photo_upload'
      get 'preview_reservations'
      get 'preload_reservations'
    end

    resources :photos, only: [:create, :destroy]

    resources :reservations, only: [:create] do
      member do
        post 'approve'
        post 'decline'
      end

      collection do
        get 'preload'
        get 'preview'
      end  
    end

    resources :calendars
    resources :guest_reviews, only: [:create, :destroy]
  end

  # Host reviews
  resources :host_reviews, only: [:create, :destroy]

  # Reservations routes
  get 'previous_reservations', to: 'reservations#previous_reservations'
  get 'current_reservations', to: 'reservations#current_reservations'

  # Dashboard
  get 'dashboard', to: 'dashboards#index'

  # Revenue management
  resources :revenues, only: [:index]

  # Conversations and messages
  resources :conversations, only: [:index, :create, :destroy] do
    resources :messages, only: [:index, :create, :destroy]
  end

  # User settings and notifications
  get 'host_calendar', to: 'calendars#host'
  get 'payment_method', to: 'users#payment'
  get 'payout_method', to: 'users#payout'
  post 'add_card', to: 'users#add_card'

  get 'notification_settings', to: 'settings#edit'
  post 'notification_settings', to: 'settings#update'
  delete 'notification_settings', to: 'settings#destroy'

  get 'notifications', to: 'notifications#index'

  # Action Cable
  mount ActionCable.server => '/cable'
end
