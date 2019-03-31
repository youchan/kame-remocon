class CanvasView
  include Hyalite::Component

  def create_image
    canvas = @refs[:canvas].native
    `canvas.toDataURL()`
  end

  def component_did_mount
    el = @refs[:canvas]
    @canvas = Canvas.new(el.native)

    @props[:onMounted].call(@canvas)
  end

  def render
    image = nil
    if @props[:render_image]
      image = create_image
    end

    div do
      canvas(width: "400", height: "400", id: :canvas, ref: :canvas, style: {"background-color": :black})
      if image
        img(src: image, style: {"background-color": :black})
      end
    end
  end
end
