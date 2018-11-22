require 'sinatra'
require 'faraday'
require 'faraday_middleware'
require 'redis-sinatra'

CACHE_API_KEY = 'api_key'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
  require 'dotenv'
  Dotenv.load
end

register Sinatra::Cache

def client
  Faraday.new(url: ENV['JFROG_URL']) do |b|
    yield b
    b.response :raise_error
    b.adapter Faraday.default_adapter
  end
end

def basic_client
  client do |b|
    b.response :json, content_type: /json/
    b.basic_auth ENV['JFROG_USERNAME'], ENV['JFROG_PASSWORD']
  end
end

def token_client
  client do |b|
    b.basic_auth ENV['JFROG_USERNAME'], api_key
  end
end

def api_key
  settings.cache.fetch(CACHE_API_KEY, ex: 60 * 30) do
    res = basic_client.get 'api/security/apiKey'
    res = basic_client.post 'api/security/apiKey' unless res.body['apiKey']
    res.body['apiKey']
  end
end

get '/key' do
  api_key
end

get '/username' do
  ENV['JFROG_USERNAME']
end

get '/encrypted_password' do
  basic_client.get('api/security/encryptedPassword').body
end

delete '/key' do
  res = basic_client.delete('api/security/apiKey')
  settings.cache.delete(CACHE_API_KEY)
  res.body.to_s
end

get '/api/*' do
  path = params['splat'].first
  return [404, 'Not Found'] if path =~ /\Asecurity/
  token_client.get("api/#{path}").body
end
