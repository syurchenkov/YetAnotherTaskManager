Rails.application.routes.draw do
  
  get    '/login',   to: 'sessions#new'

  post   '/login',   to: 'sessions#create'
  
  delete '/logout',  to: 'sessions#destroy'

  root   'main#home'

  get    '/signup',  to: 'users#new'

  resources :users do 
    scope :module => 'users' do 
      resources :tasks, except: :index do
        member do 
          patch 'rewind', to: 'tasks#rewind'
          patch 'start', to:  'tasks#start'
          patch 'finish', to: 'tasks#finish'
        end
      end
    end
  end
end
