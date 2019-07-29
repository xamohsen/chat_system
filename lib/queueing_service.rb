class QueueingService
  def initialize (config)
    @bunny = Bunny.new(config)
    @bunny.start
    at_exit {@bunny.stop}
  end

  attr_reader :bunny, :exchange

  def start
    bunny.start
  end

  def publish(message)
    start_exchange.publish(message, :routing_key => 'message')
  end


  def start_exchange
    @exchange = channel.default_exchange
  end

  def channel
    @channel ||= bunny.channel
  end

end
