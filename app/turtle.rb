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

  def initialize(canvas)
    @canvas = canvas
    @context = @canvas.get_context("2d");
    @pos = Pos.new(0, 0)
    @pen = Struct.new(:color, :state).new("white", :up)
    @direction = 0

    @context.move_to(*@pos.canvas_coordinate)

    @kame = Image.new
    @kame.src = "/assets/images/kame.png"
    clear
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
    clear
    reset
    self.instance_eval program
    @context.stroke(@path)
    if @kame.complete
      draw_kame
    else
      @kame.onload do
        draw_kame
      end
    end
  end

  def clear
    @context.clear_rect(0, 0, @canvas.width, @canvas.height)
    @path = Canvas::Path2D.new
  end

  def reset
    @pos = Pos.new(0, 0)
    @path.move_to(*@pos.canvas_coordinate)
    @direction = 0
  end

  def turn_left(digree)
    @direction = (@direction - digree) % 360
  end

  def turn_right(digree)
    @direction = (@direction + digree) % 360
  end

  def pendown
    @pen.state = :down
    @context.stroke_style = "white"
  end

  def forward(dist)
    pos = position_to(dist)
    @path.line_to(*pos.canvas_coordinate)
    @pos = pos
  end

  def position_to(dist)
    dx = Math.sin(Math::PI * @direction / 180) * dist
    dy = - Math.cos(Math::PI * @direction / 180) * dist
    Pos.new(@pos.x + dx, @pos.y + dy)
  end
end
