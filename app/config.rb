module Config
  def self.ws_enabled?
    `document.ws_enabled`
  end
end
