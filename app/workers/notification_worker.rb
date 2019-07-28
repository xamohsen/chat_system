require 'json'

class NotificationWorker
  include Sneakers::Worker
  from_queue "notification"

  def work(message)
    retries = 0
    begin
      message = JSON.parse(message)
      @data = message["data"]
      app = send(message['method'])
      puts "App:  ", app
    rescue Exception => e
      if retries < 10
        puts "FAIL retry: #{retries} #{e}"
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

end
