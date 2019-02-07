Rails.application.routes.draw do
  # Devise routes
  devise_for :users, only: [
    :confirmations,
    :passwords,
    :registrations,
    :sessions
  ], controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_for :participants, only: [:confirmations], controllers: {
    confirmations: 'participants/confirmations'
  }

  devise_for :researchers, only: [:confirmations], controllers: {
    confirmations: 'researchers/confirmations'
  }

  devise_scope :participant do
    patch '/participants/confirm' => 'participants/confirmations#update'
  end

  devise_scope :researcher do
    patch '/researchers/confirm' => 'researchers/confirmations#update'
  end

  # Non-standard routes
  get '/studies/search', to: 'studies#search', as: :search_studies
  get '/studies/:id/stats', to: 'studies#stats', as: :study_stats
  post '/studies/:id/timeslots/finalise', to: 'timeslots#finalise', as: :finalise_study_timeslots
  get '/payments', to: 'managed_accounts#new', as: :payments
  patch '/studies/:id/feature', to: 'studies#feature', as: :feature_study

  # Application routes
  resources :studies, only: [:index, :new, :create, :show, :update] do
    resources :participations, only: [:index, :update], controller: 'studies_participations'
    resources :non_user_participants, only: [:create]
    resources :timeslots, only: [:index, :new, :create, :destroy]
    resources :payments, only: [:create]
    resources :study_timeslots, only: [:index]
  end
  resources :managed_accounts, only: [:create]
  resources :universities, only: [:index, :new, :create]
  resources :profile, only: [:index]
  resources :participations, only: [:create, :edit, :update]
  resources :ratings, only: [:create]

  # Public routes
  get 'contact', to: 'contact#new'
  post 'contact', to: 'contact#create', as: 'contacts'

  get 'faq', to: 'faq#index', as: 'faq'
  get 'terms', to: 'terms#index', as: 'terms'
  get 'vision', to: 'vision#index', as: 'vision'

  root 'home#index'
end
