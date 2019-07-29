class MessageController < ApplicationController
  def search
    if params[:app_token] and params[:chat_number] and params[:text]
      messages = Message.search_chat({text: params[:text],
                                      app_token: params[:app_token],
                                      chat_number: params[:chat_number]}).records
    end
    json_response(messages)
  end

  def index
    messages = Message.where(app_token: params[:app_token],
                             chat_number: params[:chat_number])
    json_response(messages)
  end

  def show
    message = Message.where(app_token: params[:app_token],
                            chat_number: params[:chat_number],
                            message_number: params[:message_number]).first
    json_response(message)
  end

  def create
    if validate_create_request params
      message = generate_message_object params
      messaging_service.publish({:data => message, :method => "create_message"}.to_json)
      json_response(message, :created)
    else
      json_response(nil, 404)
    end
  end

  def update
    if params and params[:message]
      @message = Message.where app_token: params[:message][:app_token],
                               chat_number: params[:message][:chat_number],
                               message_number: params[:message][:message_number]

      @message.update(text: params[:message][:text])
      json_response(@message, :ok)
    else
      json_response(nil, :not_found)
    end
  end

  private
  def generate_message_object(params)
    params[:message][:message_number] = get_chat_messages_count params
    params[:message]
  end
  def get_chat_messages_count (params)
    chat_messages_count = "app:#{params[:message][:app_token]}chat:#{params[:message][:chat_number]}"
    if $redis.get chat_messages_count == nil
      $redis.set chat_messages_count,
                 Chat.find_by(:app_token => params[:message][:app_token],
                              :chat_number => params[:message][:chat_number]
                 ).messages_count
    end
    $redis.incr chat_messages_count
    $redis.get(chat_messages_count).to_i
  end

  def message_params
    # whitelist params
    if params and params[:message]
      params.require(:message).permit(:app_token, :chat_number, :message_number, :text)
    end
  end

  def validate_create_request(params)
    return params != nil &&
        params[:message] != nil &&
        params[:message][:app_token] != nil &&
        params[:message][:chat_number] != nil &&
        params[:message][:text] != nil
  end
end
