Rails.application.routes.draw do
  get 'tasks/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ## Main Dashboard
  get "/", to: "dashboard#show", as: :dashboard
end
