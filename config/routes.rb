Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, except: [:create, :destroy, :update]
      resources :identities
      resources :items
      resources :containers
    end
  end

  resources :users
  resources :items
  resources :containers
  resources :identities, except: [:create, :edit, :update]

  get '/'=>'welcome#index', as: :root
  get 'welcome/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # from https://coderwall.com/p/bsfitw/ruby-on-rails-4-authentication-with-facebook-and-omniauth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
