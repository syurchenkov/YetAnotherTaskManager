Rails.application.routes.draw do
  
  get    '/login',   to: 'sessions#new'

  post   '/login',   to: 'sessions#create'
  
  delete '/logout',  to: 'sessions#destroy'

  root 'main#home'

  get  '/signup',  to: 'users#new'

  resources :users do 
    scope :module => 'users' do 
      resources :tasks
    end
  end
end
