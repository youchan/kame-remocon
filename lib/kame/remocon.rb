require_relative "remocon/version"

require 'menilite'
require "drb/websocket"
require 'sinatra/activerecord'

require_relative "remocon/remote_object"
require_relative "remocon/server"
Dir[File.expand_path('../app/models/', __FILE__) + '/**/*.rb'].each {|file| require(file) }
Dir[File.expand_path('../app/controllers/', __FILE__) + '/**/*.rb'].each {|file| require(file) }

module Kame
  module Remocon
    class Error < StandardError; end
  end
end

app = Rack::Builder.app do
  server = Kame::Remocon::Server.new(host: 'localhost')

  map '/' do
    run server
  end

  map '/assets' do
    run Kame::Remocon::Server::OPAL.sprockets
  end

  map '/api' do
    router = Menilite::Router.new
    run router.routes(server.settings)
  end
end

Thread.new do
  thin = Rack::Handler.get('thin')
  thin.run(DRb::WebSocket::RackApp.new(app), Host: "127.0.0.1", Port: 9292)
end.run
