class CanvasView
  include Hyalite::Component


  def component_did_mount
    el = @refs[:canvas]
    @canvas = Canvas.new(el.native)

    @props[:onMounted].call(@canvas)
  end

  def render
    canvas({width: "400", height: "400", ref: :canvas, style: {"background-color": "black"}})
  end
end
