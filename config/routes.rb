require 'sidekiq/web'

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
      registrations: 'registrations'
    }

  root :to => 'home#index'

  resources :receipts, only: [:update, :index, :new]
  resources :deliveries, only: [:index, :new, :create, :destroy]
  get '/deliveries/:date' => "deliveries#index"
  resources :users, only: [:index, :show, :create]
  resources :recipients, only: [:index, :create]

  scope '/accounts' do
    resource :address, as: :forwarding_address, controller: :forwarding_addresses, only: [:create, :update] do
      get 'subregions'
    end
  end

  resources :roles, controller: :user_roles, as: :user_roles, only: [:index, :create, :destroy]
  get '/roles/:title' => "user_roles#index"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
