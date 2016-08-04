require 'pry'
require 'rack/test'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift File.expand_path('../../', __FILE__)
require 'app'

ENV['JFROG_URL'] = 'https://dummy.jfrog.io/dummy'
ENV['JFROG_USERNAME'] = 'dummy_user'
ENV['JFROG_PASSWORD'] = 'dummy_password'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
