Rails.application.routes.draw do
  get 'welcome/index'
  post '/students/:student_id/schedules/overview', to: 'schedules#overview', as: 'overview_student_schedule'

  resources :students do
    resources :schedules
  end

  # root 'students#new'
  root 'welcome#index'
end
