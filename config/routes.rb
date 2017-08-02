Rails.application.routes.draw do
  
  get    '/login',   to: 'sessions#new'

  post   '/login',   to: 'sessions#create'
  
  delete '/logout',  to: 'sessions#destroy'

  root   'main#home'

  get    '/signup',  to: 'users#new'

  resources :users do 
    scope :module => 'users' do 
      resources :tasks, except: :index
      patch 'tasks/:id/rewind', to: 'tasks#rewind', as: :task_rewind
      patch 'tasks/:id/start',  to: 'tasks#start',  as: :task_start
      patch 'tasks/:id/finish', to: 'tasks#finish', as: :task_finish
    end
  end
end
