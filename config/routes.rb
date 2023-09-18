Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  get "chats/refresh", as: "refresh"
  resources :feedbacks
  resources :chats
  root "chats#index"
end
