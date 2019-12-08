Rails.application.routes.draw do
  root 'application#home'
  get 'static_pages/home', as: :home_page #I named this route "home_page" see page 19 in Ruby Guides on Routes chapter. 
  get 'static_pages/help'
  get 'static_pages/about' #this url allows a url like http://localhost:3000/static_pages/about
  # get 'about', action: :about, controller: 'static_pages' #this route allows a url like http://localhost:3000/about
  get 'static_pages/contact'
end
