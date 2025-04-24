Rails.application.routes.draw do
  devise_for :users

  # Projects with nested comments
  resources :projects do
    resources :comments, only: :create
  end

  # Root page
  root "projects#index"
end
