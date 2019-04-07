require_relative "remocon/version"

if RUBY_ENGINE == "opal"
  require_relative "remocon/opal/application"
else
  require "drb/websocket"
  require "launchy"

  require_relative "remocon/remote_object"
  require_relative "app"

  module Kame
    module Remocon
      class Error < StandardError; end
    end
  end
end
