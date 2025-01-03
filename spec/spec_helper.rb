# frozen_string_literal: true

require 'pry'
require 'rack/test'
require 'webmock/rspec'
require 'rspec/its'

ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift File.expand_path('..', __dir__)
require 'app'

ENV['JFROG_URL'] = 'https://dummy.jfrog.io/dummy'
ENV['JFROG_USERNAME'] = 'dummy_user'
ENV['JFROG_PASSWORD'] = 'dummy_password'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
