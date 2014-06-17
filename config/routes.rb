Todo::Application.routes.draw do
  #devise_for :users

  namespace :api, defaults: {format: :json} do
    resources :teams
    resources :users, only: :index
  end

  root :to => "teams#index"
  get '/dashboard' => 'teams#index'
  get '/search' => 'teams#index'
  get '/task_lists/:id' => 'teams#index'

  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }


end
