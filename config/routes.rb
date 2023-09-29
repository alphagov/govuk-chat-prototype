Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  get "chats/refresh", as: "refresh"
  get "access-denied", to: "access_denied#index", format: false
  resources :feedbacks
  resources :chats
  root "chats#index"
end
