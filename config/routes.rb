Rails.application.routes.draw do
  resources :feedbacks
  resources :chats
  root "chats#index"
end
