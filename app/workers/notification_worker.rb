require 'json'

class NotificationWorker
  include Sneakers::Worker
  from_queue "notification"

  def work(data)
    retries = 0
    begin
      data = JSON.parse(data)
      puts "Data: ", data
      app = ChatApp.create data
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

end
