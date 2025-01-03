# frozen_string_literal: true

require_relative 'lib/app'
require 'rack/cache'

use Rack::Cache,
    metastore: "file://#{File.expand_path('.cache/meta', __dir__)}",
    entitystore: "file://#{File.expand_path('.cache/entity', __dir__)}"

run Sinatra::Application
