Rails.application.routes.draw do
  root 'books#index'
  resources :books
  resources :authors  # Змініть з only: [:index, :show] на повний ресурс
end
