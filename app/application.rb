require 'hyalite'
require "opal-parser"

require_relative "views/canvas_view"
require_relative "canvas"
require_relative "turtle"


class AppView
  include Hyalite::Component

  def initialize
    @program = <<~PROG
      pendown
      forward(100)
      turn_left(90)
      forward(100)
      turn_left(90)
      forward(100)
      turn_left(90)
      forward(100)
    PROG
  end

  def mounted(canvas)
    @turtle = Turtle.new(canvas)
    @turtle.exec @program
  end

  def exec
    @program = @refs[:program].value
    @turtle.exec @program
  end

  def render
    program = @program
    div do
      h2(nil, 'タートルグラフィックスに挑戦！！')
      CanvasView.el(onMounted: -> canvas { mounted(canvas) })
      textarea({style: {width: "400px", height: "200px"}, ref: :program}, program)
      button({onClick: -> { exec() }, name: "exec"}, "Exec")
    end
  end
end
Hyalite.render(Hyalite.create_element(AppView), $document['.content'])
