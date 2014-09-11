require 'sidekiq/web'
require 'sidetiq/web'

Besko::Application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      sign_up: 'signup',
      registration: 'accounts'
    },
    controllers: {
      passwords: 'passwords',
      registrations: 'registrations',
      sessions: "sessions"
    },
    skip: %w( registrations )

  post "/login/touchstone", to: "shibboleth_sessions#create", as: :shibboleth_session

  authenticated :user do
    root to: redirect('/receipts')
  end

  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root

    get '/accounts/edit' => 'registrations#edit', as: :edit_user_registration
    patch '/accounts' => 'registrations#update', as: :user_registration
  end

  resources :receipts, only: [:update, :index, :new]
  resources :deliveries, only: [:index, :new, :create, :destroy]
  resources :users, only: [:index, :show, :create]

  scope '/accounts' do
    resource :address, as: :forwarding_address, controller: :forwarding_addresses, only: [:create, :update]
    scope 'address' do
      resources :subregions, only: :index
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
