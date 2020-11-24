Rails.application.routes.draw do
  get 'welcome/index'
  post '/students/:student_id/schedules/overview', to: 'schedules#overview', as: 'overview_student_schedule'
  get '*unmatched_route', to: 'application#not_found'

  resources :students do
    resources :schedules
  end

  # root 'students#new'
  root 'welcome#index'
end
