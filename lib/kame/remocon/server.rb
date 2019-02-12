require 'sinatra'
require 'opal'
require 'opal/sprockets'

# if development?
  # require 'sinatra/reloader'
# end

class Kame::Remocon::Server < Sinatra::Base
  OPAL = Opal::Sprockets::Server.new do |server|
    server.append_path File.expand_path("../opal", __FILE__)
    server.append_path File.expand_path("../assets", __FILE__)
    #server.append_path File.expand_path("../../../", __FILE__)
    Opal.use_gem 'hyalite'
    Opal.use_gem "opal-drb"
    Opal.use_gem 'kame-remocon'
    Opal.paths.each {|path| server.append_path path }

    server.main = 'application'
  end

  configure do
    set opal: OPAL
    enable :sessions
    set :protection, except: :json_csrf

    remote_object = RemoteObject.new
    set :remote_object, remote_object

    DRb::WebSocket::RackApp.config.use_rack = true
    DRb.start_service("ws://127.0.0.1:9292", remote_object)
  end

  get '/' do
    @enable_ws = true
    haml :index
  end

  get "/polygon/:n" do
    n = params["n"].to_i

    EM.defer do
      settings.remote_object.exec_bulk do
        forward 100
        turn_left 90
        backward(Math::PI * 100 / n)

        pen_down
        n.times do
          forward(Math::PI * 200 / n)
          turn_left(360 / n)
        end
      end
    end
  end

  post "/exec" do
    body = request.body.read
    EM.defer do
      settings.remote_object.exec_bulk body
    end
  end

  get "/favicon.ico" do
  end
end

