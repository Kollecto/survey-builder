Rails.application.routes.draw do

  # ADMIN ROUTES
  namespace :admin do
    get '/' => 'base#dashboard'

    resources :survey_iterations do
      member do
        post 'import_from_gd'
        post 'reimport_from_gd'
        post 'publish_to_sg'
        post 'cancel_publish_to_sg'
        post 'delete_from_sg'
      end
      resources :survey_pages do
        resources :survey_questions do
          resources :survey_options
        end
      end
      resources :survey_questions do
        resources :survey_options
      end
      resources :survey_submissions
    end
    resources :survey_pages do
      resources :survey_questions do
        resources :survey_options
      end
    end
    resources :survey_questions do
      resources :survey_options
    end
    resources :survey_options
    resources :survey_submissions
    resources :users do
      post 'become', :on => :member
      resources :survey_submissions
    end
  end

  resources :taste_categories
  resources :survey_submissions do
    get 'take_survey', on: :member, as: 'take'
  end
  resources :survey_options
  resources :survey_pages
  resources :survey_iterations
  resources :survey_questions

  devise_for :users, controllers: { registrations: 'registrations' }

  get 'start' => 'survey_submissions#start'
  get   'google_auth_callback' => 'home#google_auth_callback'
  delete 'google_auth_signout' => 'home#google_auth_signout'
  root 'home#home'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
