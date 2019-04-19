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
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "opal", "~> 0.11"
  spec.add_dependency "opal-sprockets", "~> 0.4.3"
  spec.add_dependency "sinatra", "~> 2.0"
  spec.add_dependency "thin", "~> 1.7"
  spec.add_dependency "hyalite", "~> 0.3"
  spec.add_dependency "rake", "~> 12.3"
  spec.add_dependency "haml", "~> 5.0"
  spec.add_dependency "sass", "~> 3.7"
  spec.add_dependency "opal-drb", "~> 0.4"
  spec.add_dependency "drb-websocket", "~> 0.5"
  spec.add_dependency "launchy", "~> 2.4"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
end
