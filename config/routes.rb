Rails.application.routes.draw do
  get "chats/refresh", as: "refresh"
  resources :feedbacks
  resources :chats
  root "chats#index"
end
