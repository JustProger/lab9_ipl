Rails.application.routes.draw do
  # post '/maincontr/result'
  post '/result', to: 'maincontr#result'

  root "maincontr#input"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
