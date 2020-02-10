Rails.application.routes.draw do
  root 'home#index'
  get 'reader', to: 'home#reader', as: :reader

  resources :feeds
end
