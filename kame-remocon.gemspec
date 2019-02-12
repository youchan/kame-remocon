lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kame/remocon/version"

Gem::Specification.new do |spec|
  spec.name          = "kame-remocon"
  spec.version       = Kame::Remocon::VERSION
  spec.authors       = ["youchan"]
  spec.email         = ["youchan01@gmail.com"]

  spec.summary       = %q{Turtle Graphics}
  spec.description   = %q{This is a remote controller to command for the turtle draw graphics.}
  spec.homepage      = "https://github.com/youchan/kame-remocon"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'thin'
  spec.add_dependency 'opal-haml'
  spec.add_dependency 'hyalite'
  spec.add_dependency 'rake'
  spec.add_dependency 'haml'
  spec.add_dependency 'sassc'
  spec.add_dependency "opal-drb"
  spec.add_dependency "drb-websocket"
  spec.add_dependency "launchy"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
