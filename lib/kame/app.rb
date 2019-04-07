module Kame
  module App
    def self.start(context=nil)
      require_relative "remocon/server"

      remote_object = nil

      app = Rack::Builder.app do
        server = Kame::Remocon::Server.new(host: 'localhost')

        remote_object = server.settings.remote_object

        map '/' do
          run server
        end

        map '/assets' do
          run Kame::Remocon::Server::OPAL.sprockets
        end
      end

      Thread.new do
        thin = Rack::Handler.get('thin')
        thin.run(DRb::WebSocket::RackApp.new(app), Host: "127.0.0.1", Port: 9292)
      end.run

      10.times do
        sleep 2
        if defined? Rack::Handler::Thin
          Launchy.open("http://localhost:9292")
          break
        end
      end

      @remote_object = remote_object

      print "Waiting for the client is up"

      100.times do
        if @remote_object.turtle
          puts
          commander = @remote_object.turtle.new_commander

          if context
            Commander::METHODS.each do |name|
              context.define_singleton_method(name) do |*args|
                commander.method_missing(name, *args)
              end
            end
          end

          break commander
        end
        print "."
        sleep(1)
      end
    end
  end
end
