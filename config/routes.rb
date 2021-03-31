Rails.application.routes.draw do
  get 'methods/edit'
  get 'methods/_form'
  get 'tasks/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ## Main Dashboard
  get "/", to: "dashboard#show", as: :dashboard

  ## Tasks      
  get "/tasks",              to: "dashboard#show"
  get "/tasks/show/:short",  to: "tasks#show", as: :task
  get "/tasks/edit/:short",  to: "tasks#edit", as: :edit_task
  get "/tasks/new",          to: "tasks#new", as: :new_task
  post "/tasks/edit/:short", to: "tasks#update", as: :update_task
  post "/tasks/new",         to: "tasks#create", as: :create_task
  get "/tasks/testing",      to: "tasks#text_editor", as: :text_editor

  ## Task Methods
  get "/tasks/show/:short/methods",            to: "methods#index", as: :task_method
  get "/tasks/edit/:short/methods/new",        to: "methods#new", as: :new_task_method
  post "/tasks/edit/:short/methods/new",       to: "methods#create", as: :create_task_method
  get "/tasks/edit/:short/methods/edit/:id",   to: "methods#edit", as: :edit_task_method
  post "/tasks/edit/:short/methods/edit/:id",  to: "methods#update", as: :update_task_method
end
