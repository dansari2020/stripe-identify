Rails.application.routes.draw do
  root 'pages#home'
  post 'create-verification-session', to: 'verification_sessions#create'
  get 'verification-webhook', to: 'verification_sessions#webhook'
  post 'verification-webhook', to: 'verification_sessions#webhook'
  put 'verification-webhook', to: 'verification_sessions#webhook'
  get 'verification_report/:id', to: 'verification_sessions#verification_report'
  post 'verifications', to: 'verification_sessions#search'
  get 'verifications', to: 'verification_sessions#index'
  get 'verifications/:id', to: 'verification_sessions#show', as: :retrieve_verification
  get 'submitted', to: 'pages#submitted', as: :submitted
  resources :events, only: [:index]
end
