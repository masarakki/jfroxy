require 'spec_helper'
require 'base64'
require 'uri'

describe :App do
  def app
    Sinatra::Application
  end

  def base64(user, pass)
    str = Base64.urlsafe_encode64([user, pass].join(':'))
    "Basic #{str}"
  end

  def url(path)
    [ENV['JFROG_URL'], path].join
  end

  let(:basic_auth) { base64(ENV['JFROG_USERNAME'], ENV['JFROG_PASSWORD']) }
  let(:token_auth) { base64(ENV['JFROG_USERNAME'], token) }
  let(:token) { 'hello_world' }
  let(:encrypted_password) { 'PASSWORD' }

  before do
    stub_request(:get, url('/api/security/apiKey')).
      with(headers: {'Authorization' => basic_auth}).
      to_return(status: 200,
                body: { apiKey: token }.to_json,
                headers: {
                  'Content-Type' => 'application/json'
                })
    stub_request(:get, url('/api/security/encryptedPassword')).
      with(headers: {'Authorization' => basic_auth}).
      to_return(status: 200,
                body: encrypted_password,
                headers: {
                  'Content-Type' => 'text/html'
                })
  end

  describe 'GET /key' do
    it do
      get '/key'
      expect(last_response.body).to eq token
    end
  end

  describe 'GET /encrypted_password' do
    it do
      get '/encrypted_password'
      expect(last_response.body).to eq encrypted_password
    end
  end

  describe 'DELETE /key' do
    it do
      stub_request(:delete, url('/api/security/apiKey')).
        with(headers: { 'Authorization'=> basic_auth }).
        to_return(status: 200, body: '')
      delete '/key'
    end
  end

  describe 'GET /api/npm/npm/auth/jfrog' do
    context 'text/plain' do
      let(:body) { '@jfrog:repository=hello' }
      it do
        stub_request(:get, url('/api/npm/npm/auth/jfrog')).
          with(headers: { 'Authorization' => token_auth }).
          to_return(status: 200, body: body)
        get '/api/npm/npm/auth/jfrog'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq body
      end
    end

    context 'application/json' do
      let(:body) { { hello: 'world' }.to_json }
      it do
        stub_request(:get, url('/api/npm/npm/auth/jfrog')).
          with(headers: { 'Authorization' => token_auth }).
          to_return(status: 200, body: body, headers: {
                      'Content-Type' => 'application/json'
                    })
        get '/api/npm/npm/auth/jfrog'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq body
      end

    end
  end


  describe 'GET /api/security/*' do
    it do
      get '/api/security/apiKey'
      expect(last_response.status).to eq 404
    end
  end
end
