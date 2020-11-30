Rails.application.routes.draw do
  get 'welcome/index'

  resources :students do
    resources :schedules
  end

  get '*unmatched_route', to: 'application#not_found'
  root 'welcome#index'
end
