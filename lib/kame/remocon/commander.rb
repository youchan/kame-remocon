class Commander
  attr_reader :commands

  def initialize(forward = nil)
    if forward
      @forward = forward
    else
      @commands = []
    end
  end

  def <<(command)
    if @forward
      @forward.method(command.first).call(*command[1..-1])
    else
      @commands << command
    end
  end

  def clear
    self << [:clear]
  end

  def reset
    self << [:reset]
  end

  def turn_left(digree)
    self << [:turn_left, digree]
  end

  def turn_right(digree)
    self << [:turn_right, digree]
  end

  def pen_down
    self << [:pen_down]
  end

  def pen_up
    self << [:pen_up]
  end

  def forward(dist)
    self << [:forward, dist]
  end

  def backward(dist)
    self << [:forward, -dist]
  end

  def move_to(x, y)
    self << [:move_to, x, y]
  end
end
