require 'redis'
Rails.application.config.autoload_paths += Dir[File.join(Rails.root, "lib", "redis_service.rb")].each {|l| require l }
