Rails.application.routes.draw do
  get "chats/refresh", as: "refresh"
  get "chats/onboarding", as: "onboarding"
  resources :feedbacks
  resources :chats
  root "chats#index"
end
