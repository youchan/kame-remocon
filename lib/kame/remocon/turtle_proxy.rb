class TurtleProxy
  def initialize(turtle)
    @turtle = DRb::DRbObject.new(turtle)
  end

  def exec(&block)
    @turtle.clear
    @turtle.reset
    self.instance_eval &block
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

  def color(color)
    @turtle.color(color)
  end

  def forward(dist)
    @turtle.forward(dist)
  end

  def backward(dist)
    @turtle.backward(dist)
  end

  def move_to(x,y)
    @turtle.move_to(x, y)
  end
end
