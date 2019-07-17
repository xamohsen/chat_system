Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #messages routs
  get '/applications/:app_token/chats/:chat_number/messages', to: 'message#index'
  get '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'message#show'
  post '/message/', to: 'message#create'
  get '/messages/search/:app_token/:chat_number/:text', to: 'message#search'
  put '/message/', to: 'chat#update'

  #chats routs
  get '/applications/:app_token/chats', to: 'chat#index'
  get '/applications/:app_token/chats/:chat_number', to: 'chat#show'
  post '/chat/', to: 'chat#create'

  #applications routs
  get '/applications/:token', to: 'chat_app#show'
  get '/applications/', to: 'chat_app#index'
  post '/application/', to: 'chat_app#create'
  put '/application/', to: 'chat_app#update'

end
