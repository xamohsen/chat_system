class MessageController < ApplicationController
  def index
    messages = Chat.joins(:chat_app)
                   .where(chat_apps: {token: params[:token]}, chats: {number: params[:number]})
                   .first().messages
    json_response(messages)
  end

  def show
    message = Chat.joins(:chat_app)
                  .where(chat_apps: {token: params[:token]}, chats: {number: params[:number]})
                  .first()
    if message != nil
      message = message.messages.find_by(number: params[:message_number])
    end
    json_response(message)
  end

  def create
    if params and params[:message]
      @chat = Chat.joins(:chat_app)
                  .where(chat_apps: {token: params[:message][:chat_app_token]},
                         chats: {number: params[:message][:chat_number]})
      if @chat and @chat.count != 0
        @chat = @chat.first
        @message = Message.create({chat_app_id: @chat.chat_app_id,
                                   chat_id: @chat.id,
                                   number: Message.last != nil ? (Message.last[:number] + 1) : 1,
                                   text: params[:message][:text]
                                  })
        @chat.update(messages_count: (@chat[:messages_count] + 1))
        json_response(@message, :created)
      end
    else
      json_response(nil, 404)
    end
  end
end
