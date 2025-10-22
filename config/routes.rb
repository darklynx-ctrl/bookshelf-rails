Rails.application.routes.draw do
  root 'books#index'
  resources :books
  resources :authors
  
  namespace :api do           
    namespace :v1 do          
      resources :books, only: [:index, :show] do
        collection do
          get :search         
        end
      end
      resources :authors, only: [:index, :show]
    end
  end
end
