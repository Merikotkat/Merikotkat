Merikotkat::Application.routes.draw do
  get "api/getringer"
  get "api/getmunicipalities"
  get "api/getspecies"
  resources :visitation_forms


  resources :external_authentication, controller: 'koala_client/external_authentication'

  get "logout" => 'koala_client/external_authentication#logout'

  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :images
  get 'visitation_forms/birds/create' => 'visitation_forms#create_bird'
  get 'visitation_forms/birds/delete' => 'visitation_forms#delete_bird'
  get 'visitation_forms/approve/:id' => 'visitation_forms#approve_form'
  get 'visitation_forms/unsubmit/:id' => 'visitation_forms#unsubmit_form'
  get 'visitation_forms/submit/:id' => 'visitation_forms#submit_form'
  get 'visitation_forms/list/:type' => 'visitation_forms#index'
  get 'visitation_forms/delete/:id' => 'visitation_forms#destroy' , as: 'destroy_visitation_form'

  get 'images/delete/:id' => 'images#delete'
  get 'images/delete/' => 'images#delete'
  get 'images/thumbnail/:id' => 'images#thumbnail'
  get 'images/thumbnail/' => 'images#thumbnail'

  get 'external_api' => 'external_apis#index'





  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
