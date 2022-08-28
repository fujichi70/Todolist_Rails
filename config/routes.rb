Rails.application.routes.draw do
  root to: 'top#index'

  devise_for :users

  post '/', to: 'top#store'
  get '/:id', to: 'top#show'
  post '/:id', to: 'top#complete'
  put '/:id', to: 'top#update'
  delete '/:id', to: 'top#destroy'

  get '/done', to: 'done#index'
  post '/done/:id', to: 'done#store'
end
