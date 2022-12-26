Rails.application.routes.draw do
  root 'pages#home'
  post 'create-verification-session', to: 'verification_sessions#create'
  get 'verification-webhook', to: 'verification_sessions#webhook'
  get 'verification/:id', to: 'verification_sessions#show'
  get 'submitted', to: 'pages#submitted', as: :submitted
end
