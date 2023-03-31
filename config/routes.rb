Rails.application.routes.draw do
  devise_for :users
  root 'top#index'
  get 'top/index'
  resources :card_lists
end
