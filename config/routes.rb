Rails.application.routes.draw do
  
  root 'main#home'

  get  '/signup',  to: 'users#new'

  resources :users

end
