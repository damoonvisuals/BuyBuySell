Buybuysell::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  # default_url_options :host => "localhost:3000"

  # Navigates /users/1/stars
  resources :users do
    # member do
    #   get :stars
    #   get :messages
    # end
  end

  # Navigates /listings/1/followers
  resources :listings, only: [:index, :new, :show, :create, :destroy] do
    member do
      get :followers
      # get :comments
    end
    resources :comments
    resources :bids, :defaults => { :biddable => 'listing' }
  end


  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  # resources :sessions, only: [:new, :create, :destroy]
  # resources :messages, only: [:create, :destroy]
  # resources :listings, only: [:create, :destroy]
  resources :listing_relationships, only: [:create, :destroy]
  get 'tags/:tag', to: 'listings#index', as: :tag


  root to: 'static_pages#home'

  # match '/signup',  to: 'users#new'
  # match '/signin',  to: 'sessions#new'
  #Should be invoked using HTTP DELETE Request
  # match '/signout', to: 'sessions#destroy', via: :delete

  devise_scope :user do
    get "signup", to: 'devise/registrations#new'
    get "signin", to: "devise/sessions#new"
    delete "signout", to: 'devise/sessions#destroy'
    # put "/confirm" => "confirmations#confirm"
  end

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'


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
  # match ':controller(/:action(/:id))(.:format)'
end
