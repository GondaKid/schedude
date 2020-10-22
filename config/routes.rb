Rails.application.routes.draw do
  get 'welcome/index'

  resources :students do
    resources :schedules
  end

  # root 'students#new'
  root 'welcome#index'
end
