Rails.application.routes.draw do
  get "experiment_a/index"
  get "experiment_a/new"
  get "experiment_b/index"
  get "experiment_b/new"
  resources :feedbacks
  resources :chats
  root "govuk_link_page#index"
end
