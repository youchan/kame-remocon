require "kame/remocon/commander"

require_relative "./image"

class Turtle
  attr_accessor :default_color

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

  def initialize(canvas, wait: 0, default_color: "white")
    @canvas = canvas
    @wait = wait
    @default_color = default_color
    @context = @canvas.get_context("2d");
    clear
    reset

    @kame = Image.new
    @kame.src = "/assets/images/kame.png"
  end

  def new_commander
    forwarder = Forwarder.new(self, *Commander::METHODS) do
      @context.clear_rect(0, 0, @canvas.width, @canvas.height)
      @paths.each do |path, color|
        @context.stroke_style = color
        @context.stroke(path)
      end
      draw_kame
    end

    DRb::DRbObject.new(Commander.new(forwarder))
  end

  class Forwarder
    def initialize(obj, *methods, &hook)
      methods.each do |name|
        define_singleton_method(name) do |*args|
          obj.method(name).call(*args)
          hook.call
        end
      end
    end
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

  def exec(program, wait=0)
    clear
    reset
    commander = Commander.new
    commander.instance_eval program
    exec_commands(commander.commands, wait: wait)
  end

  def exec_commands(commands, wait: nil)
    wait ||= @wait
    if wait > 0
      exec = Proc.new do
        if commands.length == 0
          false
        else
          exec_command(commands.shift)
          @context.clear_rect(0, 0, @canvas.width, @canvas.height)
          @paths.each do |path, color|
            @context.stroke_style = color
            @context.stroke(path)
          end
          draw_kame
          true
        end
      end
      interval = wait * 1000
      %x(
        var timer = setInterval(function() {
          if (!exec()) { clearInterval(timer); }
        }, interval);
      )
    else
      commands.each(&self.method(:exec_command))
      @paths.each do |path, color|
        @context.stroke_style = color
        @context.stroke(path)
      end
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
    self.method(command.first).call(*command[1..-1])
    nil
  end

  def clear
    @context.clear_rect(0, 0, @canvas.width, @canvas.height)
    @path = Canvas::Path2D.new
    @paths = [[@path, @default_color]]
    nil
  end

  def reset
    @pen_down = false
    @direction = 0
    @pos = Pos.new(0, 0)
    @path.move_to(*@pos.canvas_coordinate)
    @context.move_to(*@pos.canvas_coordinate)
    nil
  end

  def turn_left(digree)
    @direction = (@direction - digree) % 360
    nil
  end

  def turn_right(digree)
    @direction = (@direction + digree) % 360
    nil
  end

  def pen_down
    @pen_down = true
    nil
  end

  def pen_up
    @pen_down = false
    nil
  end

  def color(color)
    @path = Canvas::Path2D.new
    @path.move_to(*@pos.canvas_coordinate)
    @paths << [@path, color]
    nil
  end

  def forward(dist)
    @pos = position_to(dist)
    move
    nil
  end

  def move_to(x, y)
    @pos = Pos.new(x, y)
    move
    nil
  end

  def move
    if @pen_down
      @path.line_to(*@pos.canvas_coordinate)
    else
      @path.move_to(*@pos.canvas_coordinate)
    end
  end

  def position_to(dist)
    dx = Math.sin(Math::PI * @direction / 180) * dist
    dy = - Math.cos(Math::PI * @direction / 180) * dist
    Pos.new(@pos.x + dx, @pos.y + dy)
  end
end
