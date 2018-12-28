class TurtleProxy
  def initialize(turtle)
    @turtle = DRb::DRbObject.new(turtle)
  end

  def exec(&block)
    reset_state
    self.instance_eval &block
    @turtle.exec_commands
  end

  def reset_state
    @turtle.reset_state
  end

  def clear
    @turtle.clear
  end

  def reset
    @turtle.reset
  end

  def turn_left(digree)
    @turtle.turn_left(digree)
  end

  def turn_right(digree)
    @turtle.turn_right(digree)
  end

  def pen_down
    @turtle.pen_down
  end

  def pen_up
    @turtle.pen_up
  end

  def forward(dist)
    @turtle.forward(dist)
  end

  def backward(dist)
    @turtle.backward(dist)
  end
end
