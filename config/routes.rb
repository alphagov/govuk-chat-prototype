Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  get "chats/refresh", as: "refresh"
  get "chats/onboarding", as: "onboarding"
  get "feedbacks/complete", as: "complete"
  resources :feedbacks
  resources :chats
  root "chats#index"
end
