require 'hyalite'
require "opal-parser"
require "opal/drb"

require_relative "config"
require_relative "views/canvas_view"
require_relative "canvas"
require_relative "turtle"

=begin
# n角形

n = 5

forward 100
turn_left 90
backword(Math::PI * 100 / n)

pen_down
n.times do
  forward(Math::PI * 200 / n)
  turn_left(360 / n)
end
=end

class AppView
  include Hyalite::Component

  def initialize
    @program = <<~PROG
      pen_down
      forward 100
      turn_left 90
      forward 100
      turn_left 90
      forward 100
      turn_left 90
      forward 100
    PROG
  end

  def mounted(canvas)
    @turtle = Turtle.new(canvas)
    @turtle.exec @program

    if Config.ws_enabled?
      @remote = DRb::DRbObject.new_with_uri "ws://127.0.0.1:9292"
      DRb.start_service("ws://127.0.0.1:9292/callback")
      @remote.set_turtle DRb::DRbObject.new(@turtle)
    end
  end

  def exec
    @program = @refs[:program].value
    wait = @refs[:wait][:checked] ? 0.3 : 0
    @turtle.exec @program, wait
  end

  def render
    program = @program
    div do
      h2(nil, 'タートルグラフィックスに挑戦！！')
      CanvasView.el(onMounted: -> canvas { mounted(canvas) })
      textarea({style: {width: "400px", height: "200px"}, ref: :program}, program)
      input({type: :checkbox, checked: true, id: :wait, ref: :wait})
      label({for: :wait}, "描く過程を表示する")
      button({onClick: -> { exec() }, name: "exec"}, "Exec")
    end
  end
end
Hyalite.render(Hyalite.create_element(AppView), $document['.content'])
