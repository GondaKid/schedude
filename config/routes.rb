Rails.application.routes.draw do
  get 'welcome/index'

  resources :students do
    resources :schedules
  end

  root 'students#new'
end
