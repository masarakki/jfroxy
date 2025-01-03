# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'uri'
require 'redis'

describe 'App' do
  def app
    Sinatra::Application
  end

  def base64(user, pass)
    str = Base64.urlsafe_encode64([user, pass].join(':'))
    "Basic #{str}"
  end

  def url(path)
    [ENV.fetch('JFROG_URL', nil), path].join
  end

  def redis = Redis.new

  subject { last_response }

  let(:basic_auth) { base64(ENV.fetch('JFROG_USERNAME', nil), ENV.fetch('JFROG_PASSWORD', nil)) }
  let(:token_auth) { base64(ENV.fetch('JFROG_USERNAME', nil), token) }
  let(:token) { 'hello_world' }
  let(:encrypted_password) { 'PASSWORD' }

  before do
    redis.del 'api_key'
    stub_request(:get, url('/api/security/apiKey'))
      .with(headers: { 'Authorization' => basic_auth })
      .to_return(status: 200,
                 body: { apiKey: token }.to_json,
                 headers: {
                   'Content-Type' => 'application/json'
                 })
    stub_request(:get, url('/api/security/encryptedPassword'))
      .with(headers: { 'Authorization' => basic_auth })
      .to_return(status: 200,
                 body: encrypted_password,
                 headers: {
                   'Content-Type' => 'text/html'
                 })
  end

  describe 'GET /usrname' do
    before { get '/username' }

    its(:body) { is_expected.to eq ENV.fetch('JFROG_USERNAME', nil) }
  end

  describe 'GET /key' do
    before { get '/key' }

    its(:body) { is_expected.to eq token }
  end

  describe 'GET /encrypted_password' do
    before { get '/encrypted_password' }

    its(:body) { is_expected.to eq encrypted_password }
  end

  describe 'DELETE /key' do
    before do
      stub_request(:delete, url('/api/security/apiKey'))
        .with(headers: { 'Authorization' => basic_auth })
        .to_return(status: 200, body: '')
      delete '/key'
    end

    its(:status) { is_expected.to eq 200 }
    its(:body) { is_expected.to eq '' }
  end

  describe 'GET /api/npm/npm/auth/jfrog' do
    context 'when text/plain' do
      let(:body) { '@jfrog:repository=hello' }

      before do
        stub_request(:get, url('/api/npm/npm/auth/jfrog'))
          .with(headers: { 'Authorization' => token_auth })
          .to_return(status: 200, body: body)
        get '/api/npm/npm/auth/jfrog'
      end

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to eq body }
    end

    context 'when application/json' do
      let(:body) { { hello: 'world' }.to_json }

      before do
        stub_request(:get, url('/api/npm/npm/auth/jfrog'))
          .with(headers: { 'Authorization' => token_auth })
          .to_return(status: 200, body: body, headers: {
                       'Content-Type' => 'application/json'
                     })
        get '/api/npm/npm/auth/jfrog'
      end

      its(:status) { is_expected.to eq 200 }
      its(:body) { is_expected.to eq body }
    end
  end

  describe 'GET /api/security/*' do
    before { get '/api/security/apiKey' }

    its(:status) { is_expected.to eq 404 }
  end
end
