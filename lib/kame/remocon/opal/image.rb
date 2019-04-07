class Image
  include Native
  include Native::Helpers

  def initialize
    super `new Image()`
  end

  alias_native :src=
  alias_native :complete

  def onload(&block)
    `#@native.onload = block`
  end
end
