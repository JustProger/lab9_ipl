Rails.application.routes.draw do
  get 'maincontr/input'
  get 'maincontr/show'
  root "maincontr#input"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
