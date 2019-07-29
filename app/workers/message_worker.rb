require 'json'

class MessageWorker
  include Sneakers::Worker
  from_queue "message"

  def work(message)
    retries = 0
    begin
      message = JSON.parse(message)
      @data = message["data"]
      data = send(message['method'])
      puts "Task Done", data
    rescue Exception => e
      if retries < 10
        puts "FAIL retry: #{retries} #{e}, Message: #{message}"
        retries += 1
        retry
      else
        puts "rejected"
        reject!
      end
    end
    ack!
  end

  def create_application
    ChatApp.create @data
  end

  def create_chat
    chat = Chat.create @data
    app = ChatApp.find_by(:token => chat[:app_token])
    app.update(chats_count: app[:chats_count] + 1)
    chat
  end

  def create_message
    message = Message.create @data
    chat = Chat.find_by(:chat_number => message[:chat_number],
                        :app_token => message[:app_token])
    chat.update(messages_count: chat[:messages_count] + 1)
    message
  end

end
