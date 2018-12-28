require 'bundler/setup'
Bundler.require(:default)

require 'menilite'
require "drb/websocket"
require 'sinatra/activerecord'

require_relative "remote_object"
require_relative 'server'
Dir[File.expand_path('../app/models/', __FILE__) + '/**/*.rb'].each {|file| require(file) }
Dir[File.expand_path('../app/controllers/', __FILE__) + '/**/*.rb'].each {|file| require(file) }

app = Rack::Builder.app do
  server = Server.new(host: 'localhost')

  map '/' do
    run server
  end

  map '/assets' do
    run Server::OPAL.sprockets
  end

  map '/api' do
    router = Menilite::Router.new
    run router.routes(server.settings)
  end
end

thin = Rack::Handler.get('thin')
thin.run(DRb::WebSocket::RackApp.new(app), Host: "127.0.0.1", Port: 9292)
