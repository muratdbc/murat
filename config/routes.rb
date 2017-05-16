Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :rental

  resources :users do
    resources :jobs
  end

  get '/jobs-sync', to: 'jobsync#sync'
end
