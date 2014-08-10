default[:redis][:dir] = "/etc/redis"
default[:redis][:data_dir] = "/var/lib/redis"
default[:redis][:log_dir] = "/var/log/redis"
# one of: debug, verbose,notice, warning
default[:redis][:loglevel] = "notice"
default[:redis][:user] = "redis"
default[:redis][:port] = 6739
default[:redis][:bind] = "127.0.0.1"
default[:redis][:pid_dir] = "/var/run/redis"
default[:redis][:pid_file] = "/var/run/redis/redis_6739.pid"
default[:redis][:log_file] = "/var/log/redis/redis_6739.log"
default[:redis][:con_file] = "/etc/redis/redis.conf"
