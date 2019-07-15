Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/applications/:token/chats', to: 'chat#index'

  get '/application/:token', to: 'chat_app#show'
  get '/applications/', to: 'chat_app#index'
  post '/application/', to: 'chat_app#create'
end
