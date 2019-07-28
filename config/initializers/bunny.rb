MESSAGING_SERVICE = QueueingService.new({:host => "rabbitmq", :user => "rabbitmq", :password => "rabbitmq"})
MESSAGING_SERVICE.start