require 'json'

class NotificationWorker
  include Sneakers::Worker
  from_queue "notification"

  def work(message)
    retries = 0
    begin
      message = JSON.parse(message)
      @data=  message["data"]
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

end
