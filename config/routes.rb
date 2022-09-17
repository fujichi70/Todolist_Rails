Rails.application.routes.draw do
  root 'tops#index'

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :dones, except: [:create, :new, :edit]
  post 'dones/start', to: 'dones#start'
  post 'dones/end', to: 'dones#end'
  post 'dones/add', to: 'dones#add'
  delete 'dones', to: 'dones#delete'
  
  get 'csv', to: 'dones#csv'
  get 'csv/date', to: 'dones#csvDate'

  post '/', to: 'tops#create'
  get '/:id', to: 'tops#show'
  post '/:id', to: 'tops#complete'
  put '/:id', to: 'tops#update'
  delete '/:id', to: 'tops#destroy'

end
