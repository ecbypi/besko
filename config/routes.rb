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
    },
    skip: %w( registrations )
  devise_scope :user do
    get '/accounts/edit' => 'registrations#edit', as: :edit_user_registration
    patch '/accounts' => 'registrations#update', as: :user_registration
  end

  root :to => 'home#index'

  resources :receipts, only: [:update, :index, :new]
  resources :deliveries, only: [:index, :show, :new, :create, :destroy]
  resources :users, only: [:index, :show, :create]
  resources :recipients, only: [:index, :create]

  scope '/accounts' do
    resource :address, as: :forwarding_address, controller: :forwarding_addresses, only: [:create, :update] do
      get 'subregions'
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
