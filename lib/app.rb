require 'sinatra'
require 'faraday'
require 'faraday_middleware'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
  require 'dotenv'
  Dotenv.load
end

def client
  Faraday.new(url: ENV['JFROG_URL']) do |b|
    b.adapter Faraday.default_adapter
    yield b
  end
end

def basic_client
  client do |b|
    b.response :json, content_type: /json/
    b.basic_auth ENV['JFROG_USERNAME'], ENV['JFROG_PASSWORD']
  end
end

def token_client
  res = basic_client.get 'api/security/apiKey'
  res = basic_client.post 'api/security/apiKey' unless res.body['apiKey']

  client do |b|
    b.basic_auth ENV['JFROG_USERNAME'], res.body['apiKey']
  end
end

get '/key' do
  basic_client.get('api/security/apiKey').body['apiKey']
end

delete '/key' do
  basic_client.delete('api/security/apiKey').body.to_s
end

get '/api/*' do
  path = params['splat'].first
  return [404, 'Not Found'] if path =~ /\Asecurity/
  token_client.get("api/#{path}").body
end
