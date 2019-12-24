Rails.application.routes.draw do
  get '/signup', to: 'users#new' 

  root 'application#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about' 
  get '/contact', to: 'static_pages#contact'

  resources :users
end

# get 'about', action: :about, controller: 'static_pages' #this route allows a url like http://localhost:3000/about