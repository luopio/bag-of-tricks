# production.rb
# + tune up for Dalli to work
use Rack::Cache,
  :verbose     => true,
  :metastore   => Dalli::Client.new,
  :entitystore => 'file:/var/cache/rack'

config.static_cache_control = "public, max-age=2592000"


# in controller
expires_in 10.minutes, :public => true

