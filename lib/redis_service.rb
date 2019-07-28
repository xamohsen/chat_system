$redis ||= Redis.new(host: "redis", port: 6379, db: 15)

#$redis_ns = Redis::Namespace.new(cnfg[:namespace], :redis => $redis) if cnfg[:namespace]

# To clear out the db before each test
$redis.flushdb if Rails.env = "test"