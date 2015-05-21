Resque.redis = Redis.new(:uri => 'http://localhost:6379')
Resque.after_fork = Proc.new {ActiveRecord::Base.establish_connection}
