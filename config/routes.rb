Rails.application.routes.draw do
  get 'welcome/index'

  resources :students

  root 'welcome#index'
end
