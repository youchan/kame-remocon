class Kame::Remocon::Opal::CanvasView
  include Hyalite::Component

  def create_image
    canvas = @refs[:canvas].native
    `canvas.toDataURL()`
  end

  def component_did_mount
    el = @refs[:canvas]
    @canvas = Kame::Remocon::Opal::Canvas.new(el.native)

    @props[:onMounted].call(@canvas)
  end

  def render
    image = nil
    if @props[:render_image]
      image = create_image
    end

    bg_color = @props[:bg_color]

    div({class: "wrap-canvas"}) do
      canvas(width: "400", height: "400", id: :canvas, ref: :canvas, style: {"background-color": bg_color})
      if image
        img(src: image, style: {"background-color": bg_color})
      end
    end
  end
end
