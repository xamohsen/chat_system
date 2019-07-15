class ChatController < ApplicationController
  # GET /applications/:token/chats
  def index
    @chats = Chat.joins(:chat_app).where(chat_apps: {token: params[:token]})
    json_response(@chats)
  end

  # GET /applications/:token/chats/:number
  def show
    @chat = Chat.where(number: params[:number]).joins(:chat_app).where(chat_apps: {token: params[:token]}).first
    json_response(@chat)
  end

  def create
    if params and params[:chat]
      @chat_app = ChatApp.where(token: params[:chat][:chat_app_token]).first
      if @chat_app != nil
        params[:chat][:chat_app_id] = @chat_app[:id]
        params[:chat][:number] = Chat.where(:chat_app_id => @chat_app[:id]).count + 1
        params[:chat][:messages_count] = 0
      end
      @chat = Chat.create!(chat_params)
      @chat_app.update(chats_count: (@chat_app[:chats_count] + 1));
    end
    json_response(@chat, :created)
  end

  private

  def chat_params
    # whitelist params
    if params and params[:chat]
      params.require(:chat).permit(:chat_app_id, :number, :messages_count)
    end
  end
end
