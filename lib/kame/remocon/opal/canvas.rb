require "native"

class Kame::Remocon::Opal::Canvas
  include Native

  native_accessor :width, :height

  def get_context(type)
    Context.new `#@native.getContext(type)`
  end

  def image_data
    canvas = @native
    `canvas.toDataURL()`.sub(/^.*,/, "")
  end

  class Context
    include Native
    include Native::Helpers

    alias_native :save
    alias_native :restore
    alias_native :fill_style=, :fillStyle=
    alias_native :fill_rect, :fillRect
    alias_native :clear_rect, :clearRect
    alias_native :begin_path, :beginPath
    alias_native :close_path, :closePath
    alias_native :line_to, :lineTo
    alias_native :move_to, :moveTo
    alias_native :stroke
    alias_native :stroke_style=, :strokeStyle=
    alias_native :stroke_style, :strokeStyle
    alias_native :line_width=, :lineWidth=
    alias_native :draw_image, :drawImage
    alias_native :set_transform, :setTransform
  end

  class Path2D
    include Native

    def initialize
      super `new Path2D()`
    end

    alias_native :line_to, :lineTo
    alias_native :move_to, :moveTo
  end
end
