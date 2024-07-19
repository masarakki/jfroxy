require_relative './lib/app'
require 'rack/cache'

use Rack::Cache,
    metastore: "file://#{File.expand_path('../.cache/meta', __FILE__)}",
        entitystore: "file://#{File.expand_path('../.cache/entity', __FILE__)}"

run Sinatra::Application
