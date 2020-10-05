Rails.application.routes.draw do
  get 'schedule/index'
  get 'welcome/index'
  get 'schedule/show'

  post 'schedule/create'

  resources :students

  root 'welcome#index'
end
