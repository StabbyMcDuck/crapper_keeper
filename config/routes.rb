Rails.application.routes.draw do
  resources :containers
  get '/'=>'welcome#index', as: :root 
  get 'welcome/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # from https://coderwall.com/p/bsfitw/ruby-on-rails-4-authentication-with-facebook-and-omniauth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
