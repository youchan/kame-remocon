require 'sinatra'
require 'opal'
require 'opal/sprockets'
require 'sinatra/activerecord'

if development?
  require 'sinatra/reloader'
end

class Server < Sinatra::Base
  OPAL = Opal::Sprockets::Server.new do |server|
    server.append_path 'app'
    server.append_path 'assets'
    Opal.use_gem 'hyalite'
    Opal.use_gem "opal-drb"
    Opal.use_gem 'menilite'
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
    haml :index
  end

  get "/circle" do
    turtle = settings.remote_object.proxy
    if turtle
      EM.defer do
        turtle.exec do
          n = 5

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
      "ok"
    else
      "ng"
    end
  end

  get "/favicon.ico" do
  end
end

