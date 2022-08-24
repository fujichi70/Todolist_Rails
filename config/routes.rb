Rails.application.routes.draw do
  root to: 'top#index'

  devise_for :users
  # ログイン機能
  get 'login/index'
  get 'login/show'

  get 'pages/index'
  get 'pages/show'
  # get    'tasks'     => 'tasks#index'
  # post   'tasks'     => 'tasks#store'
  # get    'tasks/:id' => 'tasks#show'
  # put    'tasks/:id' => 'tasks#update'
  # delete 'tasks/:id' => 'tasks#destroy'
end
