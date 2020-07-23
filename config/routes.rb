Rails.application.routes.draw do

  resources :chefs
  resources :recipes
  root 'pages#home'
  get 'pages/home', to: 'pages#home'
end
