Rails.application.routes.draw do
  resources :friend_requests
  devise_for :users, controllers: {
    #sessions: 'user/sessions'
    registrations: 'users/registrations'
  }
  root 'static_pages#home'
  resources :users
  resources :friendships
  resources :friend_requests
  resources :notifications
  resources :posts
  resources :comments
  resources :likes
end
