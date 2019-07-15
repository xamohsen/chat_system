Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #messages routs
  get '/applications/:token/chats/:number/messages', to: 'message#index'
  get '/applications/:token/chats/:number/messages/:message_number', to: 'message#show'
  post '/message/', to: 'message#create'

  #chats routs
  get '/applications/:token/chats', to: 'chat#index'
  get '/applications/:token/chats/:number', to: 'chat#show'
  post '/chat/', to: 'chat#create'

  #applications routs
  get '/applications/:token', to: 'chat_app#show'
  get '/applications/', to: 'chat_app#index'
  post '/application/', to: 'chat_app#create'

end
