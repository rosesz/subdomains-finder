Rails.application.routes.draw do
  root 'subdomains#index'

  resources :subdomains, only: :index
end
