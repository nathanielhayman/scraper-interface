Rails.application.routes.draw do
  get 'tasks/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ## Main Dashboard
  get "/", to: "dashboard#show", as: :dashboard

  ## Tasks
  get "/tasks",           to: "dashboard#show"
  get "/tasks/show/:short",  to: "tasks#show", as: :task
  get "/tasks/edit/:short",  to: "tasks#edit", as: :edit_task
  get "/tasks/new",       to: "tasks#new", as: :new_task
  post "/tasks/edit/:short", to: "tasks#update", as: :update_task
  post "/tasks",          to: "tasks#create", as: :create_task
end
