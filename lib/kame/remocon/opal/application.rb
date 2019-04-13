require 'hyalite'
require "opal-parser"
require "opal/drb"

require_relative "kame_remocon"

Hyalite.render(Hyalite.create_element(Kame::Remocon::Opal::AppView), $document[".turtle-graphics"])
