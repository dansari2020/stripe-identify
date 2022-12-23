Rails.application.routes.draw do
  root 'pages#home'
  post 'create-verification-session', to: 'verification_sessions#create'
  get 'submitted', to: 'pages#submitted', as: :submitted
end
