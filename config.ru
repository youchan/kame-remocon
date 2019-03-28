require 'bundler/setup'
Bundler.require(:default)

require "drb/websocket"

#require_relative "lib/kame/remocon/remote_object"
require_relative "lib/kame/remocon/server"
#Dir[File.expand_path('../app/models/', __FILE__) + '/**/*.rb'].each {|file| require(file) }
#Dir[File.expand_path('../app/controllers/', __FILE__) + '/**/*.rb'].each {|file| require(file) }

app = Rack::Builder.app do
  server = Kame::Remocon::Server.new(host: 'localhost')

  map '/' do
    run server
  end

  map '/assets' do
    run Kame::Remocon::Server::OPAL.sprockets
  end
end

thin = Rack::Handler.get('thin')
thin.run(DRb::WebSocket::RackApp.new(app), Host: "127.0.0.1", Port: 9292)
