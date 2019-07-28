require 'sneakers'
require 'sneakers/handlers/maxretry'

module Connection
  def self.sneakers
    @_sneakers ||= begin
      Bunny.new({:host => "rabbitmq", :user => "rabbitmq", :password => "rabbitmq"})
    end
  end
end


Sneakers.configure connection: Connection.sneakers,
                   workers: 5, # Number of per-cpu processes to run
                   log: STDOUT, # Log file
                   pid_path: 'sneakers.pid', # Pid file
                   timeout_job_after: 5.minutes, # Maximal seconds to wait for job
                   env: ENV['RAILS_ENV'], # Environment
                   durable: true, # Is queue durable?
                   ack: true, # Must we acknowledge?
                   heartbeat: 5, # Keep a good connection with broker
                   handler: Sneakers::Handlers::Maxretry,
                   retry_max_times: 10, # how many times to retry the failed worker process
                   retry_timeout: 3 * 60 * 1000 # how long between each worker retry duration

Sneakers.logger.level = Logger::INFO