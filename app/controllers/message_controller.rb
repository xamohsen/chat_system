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
    if params and params[:message]
      params[:message][:message_number] = Message.last != nil ? (Message.last[:message_number] + 1) : 1
      @message = Message.create!(message_params)
      @message.chat.update(messages_count: (@message.chat[:messages_count] + 1))
      json_response(@message, :created)
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

  def message_params
    # whitelist params
    if params and params[:message]
      params.require(:message).permit(:app_token, :chat_number, :message_number, :text)
    end
  end
end
