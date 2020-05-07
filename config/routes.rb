Rails.application.routes.draw do
  use_doorkeeper

  # google verify
  get 'google4b57882e82b3b0a2.html', to: 'templates#verify'

  # templates
  get 'sign_up', to: 'templates#lil_c_sign_up', as: 'lil_c_sign_up'

  # admin
  get 'ctrl_stuff', to: 'admin#index', as: 'dsa_admin'
  get 'dev', to: 'admin#dev_panel', as: 'dev_panel'
  get 'lacks_permission', to: 'admin#lacks_permission', as: 'lacks_permission'

  # views
  get 'user_views_index/:token', to: 'views#user_index', as: 'user_views_index'
  get 'anon_views_index/:token', to: 'views#anon_index', as: 'anon_views_index'
  get 'user_click_index/:token', to: 'views#click_index', as: 'user_click_index'
  post 'currently_clicking', to: 'views#create'

  # pages
  get 'resume', to: 'pages#resume', as: 'resume'
  get 'pages/scroll_to_top', as: 'scroll_to_top'
  get 'pages/toggle_menu', as: 'toggle_menu'
  get 'pages/more'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'templates#lil_c'

  resources :views

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
