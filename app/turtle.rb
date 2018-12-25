require_relative "./image"

class Turtle
  class Pos
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def move_to(x, y)
      @x = x
      @y = y
    end

    def canvas_coordinate
      [@x + 200, @y + 200]
    end
  end

  def initialize(canvas, wait: 0)
    @canvas = canvas
    @wait = wait
    @context = @canvas.get_context("2d");
    reset_state

    @kame = Image.new
    @kame.src = "/assets/images/kame.png"

    @commands = []
  end

  def reset_state
    @pen_down = false
    @direction = 0
    @path = Canvas::Path2D.new
    @pos = Pos.new(0, 0)
    @path.move_to(*@pos.canvas_coordinate)
    @context.clear_rect(0, 0, @canvas.width, @canvas.height)
    @context.stroke_style = "white"
  end

  def draw_kame
    (x, y) = @pos.canvas_coordinate

    c = Math.cos(@direction / 180 * Math::PI)
    s = Math.sin(@direction / 180 * Math::PI)
    transform = [c, s, -s, c, x - 10 * c + 10 * s, y - 10 * c - 10 * s] 
    @context.set_transform(*transform)
    @context.draw_image(@kame, 0, 0, 20, 20)
    @context.set_transform(1, 0, 0, 1, 0, 0)
  end

  def exec(program)
    reset_state
    self.instance_eval program
    exec_commands
  end

  def exec_commands
    if @wait > 0
      exec = Proc.new do
        if @commands.length == 0
          false
        else
          exec_command(@commands.shift)
          @context.clear_rect(0, 0, @canvas.width, @canvas.height)
          @context.stroke(@path)
          draw_kame
          true
        end
      end
      interval = @wait * 1000
      %x(
        var timer = setInterval(function() {
          if (!exec()) { clearInterval(timer); }
        }, interval);
      )
    else
      @commands.each(&self.method(:exec_command))
      @context.stroke(@path)
      if @kame.complete
        draw_kame
      else
        @kame.onload do
          draw_kame
        end
      end
    end
  end

  def exec_command(command)
    case command.shift
    when :clear
      @context.clear_rect(0, 0, @canvas.width, @canvas.height)
      @path = Canvas::Path2D.new
    when :reset
      @direction = 0
      @pos = Pos.new(0, 0)
      @context.move_to(*@pos.canvas_coordinate)
      @context.stroke_style = "white"
    when :turn_left
      digree = command.first
      @direction = (@direction - digree) % 360
    when :turn_right
      digree = command.first
      @direction = (@direction + digree) % 360
    when :pen_down
      @pen_down = true
    when :pen_up
      @pen_down = false
    when :forward
      dist = command.first
      @pos = position_to(dist)
      if @pen_down
        @path.line_to(*@pos.canvas_coordinate)
      else
        @path.move_to(*@pos.canvas_coordinate)
      end
    end
  end

  def clear
    @commands << [:clear]
  end

  def reset
    @commands << [:reset]
  end

  def turn_left(digree)
    @commands << [:turn_left, digree]
  end

  def turn_right(digree)
    @commands << [:turn_right, digree]
  end

  def pen_down
    @commands << [:pen_down]
  end

  def pen_up
    @commands << [:pen_up]
  end

  def forward(dist)
    @commands << [:forward, dist]
  end

  def backward(dist)
    @commands << [:forward, -dist]
  end

  def position_to(dist)
    dx = Math.sin(Math::PI * @direction / 180) * dist
    dy = - Math.cos(Math::PI * @direction / 180) * dist
    Pos.new(@pos.x + dx, @pos.y + dy)
  end
end
