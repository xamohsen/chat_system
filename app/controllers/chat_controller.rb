class ChatController < ApplicationController
  # GET /applications/:app_token/chats
  def index
    @chats = Chat.where(app_token: params[:app_token])
    json_response(@chats)
  end

  # GET /applications/:app_token/chats/:chat_number
  def show
    @chat = Chat.where(chat_number: params[:chat_number], app_token: params[:app_token]).first
    json_response(@chat)
  end

  def create
    if params and params[:chat]
      params[:chat][:chat_number] = (Chat.count + 1)
      params[:chat][:messages_count] = 0
      @chat = Chat.create!(chat_params)
      @chat.chat_app.update(chats_count: (@chat.chat_app[:chats_count] + 1))
    end
    json_response(@chat, :created)
  end

  private

  def chat_params
    # whitelist params
    if params and params[:chat]
      params.require(:chat).permit(:app_token, :chat_number, :messages_count)
    end
  end
end
