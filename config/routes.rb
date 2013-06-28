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

  scope '/mail' do
    get 'forwarding' => "mail_forwarding#new"
  end

  resources :forwarding_addresses, only: :index
  scope '/accounts' do
    resource :address, as: :forwarding_address, controller: :forwarding_addresses, only: [:create, :update] do
      get 'subregions'
    end
  end

  resources :roles, controller: :user_roles, as: :user_roles, only: [:index, :create, :destroy]
  get '/roles/:title' => "user_roles#index"

  sidekiq_constraint = lambda { |request| request.env['warden'].authenticate? && request.env['warden'].user.admin? }
  constraints sidekiq_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
