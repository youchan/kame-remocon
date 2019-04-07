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

class Kame::Remocon::Opal::AppView
  include Hyalite::Component

  state :render_image, false
  state :bg_color, "black"

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
    @turtle = Kame::Remocon::Opal::Turtle.new(canvas)
    @turtle.exec @program

    if Kame::Remocon::Opal::Config.ws_enabled?
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

  def create_image
    set_state(render_image: true)
  end

  def set_background
    bg_color = @refs[:bg_color][:checked]
    @turtle.default_color = bg_color ? "white" : "black"
    set_state(bg_color: bg_color ? "black" : "white")
  end

  def render
    program = @program
    render_image = @state[:render_image]
    bg_color = @state[:bg_color]
    div do
      h2(nil, 'タートルグラフィックスに挑戦！！')
      Kame::Remocon::Opal::CanvasView.el(onMounted: -> canvas { mounted(canvas) }, render_image: render_image, bg_color: bg_color)
      textarea({style: {width: "400px", height: "200px"}, ref: :program}, program)
      input({type: :checkbox, checked: true, id: :wait, ref: :wait})
      label({for: :wait}, "描く過程を表示する")
      input({type: :checkbox, checked: true, id: :bg_color, ref: :bg_color, onClick: -> {set_background}})
      label({for: :bg_color}, "黒背景")
      button({onClick: -> { exec }, name: "exec"}, "実行する")
      button({onClick: -> { create_image }, name: "create_image"}, "画像を作成")
    end
  end
end
