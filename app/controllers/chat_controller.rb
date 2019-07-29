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
    if validate_create_request params
      chat = generate_chat_object params

      messaging_service.publish ({:data => chat, :method => "create_chat"}.to_json)
      json_response(chat, :created)
    else
      json_response(nil, :not_found)
    end
  end

  private

  def validate_create_request(params)
    return params != nil &&
        params[:chat] != nil &&
        params[:chat][:app_token] != nil &&
        ChatApp.find_by(:token => params[:chat][:app_token]) != nil
  end

  def get_app_chats_count (params)
    application_chats_count = "chat:#{params[:chat][:app_token]}"
    if $redis.get(application_chats_count) == nil
      $redis.set(application_chats_count, ChatApp.find_by(:token => params[:chat][:app_token]).chats_count)
    end
    $redis.incr(application_chats_count)
    $redis.get(application_chats_count).to_i
  end

  def generate_chat_object(params)
    params[:chat][:chat_number] = get_app_chats_count params
    params[:chat][:messages_count] = 0
    params[:chat]
  end

  def chat_params
    # whitelist params
    if params and params[:chat]
      params.require(:chat).permit(:app_token, :chat_number, :messages_count)
    end
  end
end
