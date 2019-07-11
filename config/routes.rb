Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/application/:id', to: 'chat_app#show'
  get '/applications/', to: 'chat_app#index'

end
