Rails.application.routes.draw do
  get 'messenger', to: 'messenger#hook'
  post 'messenger', to: 'messenger#recipient'

  resources :students do
    resources :schedules
  end

  get '*unmatched_route', to: 'application#not_found'
  root 'welcome#index'
end
