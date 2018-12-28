require_relative "turtle_proxy"

class RemoteObject
  def turtle=(turtle)
    @proxy = TurtleProxy.new(turtle)
    nil
  end

  def proxy
    @proxy
  end
end
