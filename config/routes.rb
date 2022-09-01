Rails.application.routes.draw do
  root to: 'tops#index'

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'dones', to: 'dones#index'
  post 'dones', to: 'dones#store'
  put 'dones/:id', to: 'dones#update'
  delete 'dones/:id', to: 'dones#destroy'
  get 'dones/csv', to: 'dones#csv'

  post '/', to: 'tops#store'
  get '/:id', to: 'tops#show'
  post '/:id', to: 'tops#complete'
  put '/:id', to: 'tops#update'
  delete '/:id', to: 'tops#destroy'

end
