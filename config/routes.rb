Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root 'books#index'
  
  resources :books do
    collection do
      get 'import'        # Форма імпорту
      post 'import_csv'   # Обробка CSV
    end
  end
  
  resources :authors
  resources :imports, only: [:index, :show] # Перегляд імпортів
  
  # API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :books, only: [:index, :show]
      resources :authors, only: [:index, :show]
    end
  end
end
