Todo::Application.routes.draw do
  #devise_for :users

  namespace :api, defaults: {format: :json} do
    resources :teams do
      resources :team_members do
        collection do
          post :refresh
        end
      end
    end
    resources :users, only: :index
  end

  root :to => "teams#index"
  get '/dashboard' => 'teams#index'
  get '/search' => 'teams#index'
  get '/task_lists/:id' => 'teams#index'

  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }


end
