class ChatController < ApplicationController
  # GET /applications/token/chats
  def index
    @chat = Chat.joins(:chat_app).where(chat_apps: {token: params[:token]})
    json_response(@chat)
  end
end
