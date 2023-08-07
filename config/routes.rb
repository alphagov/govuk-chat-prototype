Rails.application.routes.draw do
  resources :feedbacks
  resources :chats
  root "govuk_page#index"
  get "alerts", to: "alerts#store", format: false
end
