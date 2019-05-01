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
    @code= <<~PROG
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

  def self.render(parent, &block)
    Hyalite.render(Kame::Remocon::Opal::AppView.el(on_mounted: block), parent)
  end

  def mounted(canvas)
    @canvas = canvas
    @turtle = Kame::Remocon::Opal::Turtle.new(canvas)
    @turtle.exec @code
    @code_getter = -> { @refs[:program].value }

    if Kame::Remocon::Opal::Config.ws_enabled?
      @remote = DRb::DRbObject.new_with_uri "ws://127.0.0.1:9292"
      DRb.start_service("ws://127.0.0.1:9292/callback")
      @remote.set_turtle DRb::DRbObject.new(@turtle)
    end

    @props[:on_mounted]&.call(@turtle, @remote)
  end

  def exec
    @code = @refs[:program].value
    wait = @refs[:wait][:checked] ? 0.3 : 0
    @turtle.exec @code, wait
  end

  def set_background
    bg_color = @refs[:bg_color][:checked]
    @turtle.default_color = bg_color ? "white" : "black"
    set_state(bg_color: bg_color ? "black" : "white")
  end

  def render
    code = @code
    render_image = @state[:render_image]
    bg_color = @state[:bg_color]

    div do
      div do
        Kame::Remocon::Opal::CanvasView.el(onMounted: -> canvas { mounted(canvas) }, render_image: render_image, bg_color: bg_color)
        div({class: "wrap-code-text"}, textarea({style: {width: "400px", height: "400px"}, ref: :program}, code))
      end
      div({class: :setting}) do
        ul do
          li do
            input({type: :checkbox, checked: true, id: :wait, ref: :wait})
            label({for: :wait}, "描く過程を表示する")
          end
          li do
            input({type: :checkbox, checked: true, id: :bg_color, ref: :bg_color, onClick: -> {set_background}})
            label({for: :bg_color}, "黒背景")
          end
        end
      end
      Hyalite.create_element(:p, {class: "exec-button"}, button({onClick: -> { exec }, name: "exec"}, "実行する"))
    end
  end
end
