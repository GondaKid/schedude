Rails.application.routes.draw do
  get 'welcome/index'
  post '/students/:student_id/schedules/overview', to: 'schedules#overview', as: 'overview_student_schedule'

  resources :students do
    resources :schedules
  end

  get '*unmatched_route', to: 'application#not_found'
  root 'welcome#index'
end
