Rails.application.routes.draw do
  devise_for :users

  # Projects with nested comments
  resources :projects do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  # Root page
  root "projects#index"
end
