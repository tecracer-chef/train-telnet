lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "train-telnet/version"

Gem::Specification.new do |spec|
  spec.name          = "train-telnet"
  spec.version       = TrainPlugins::Telnet::VERSION
  spec.authors       = ["Thomas Heinen"]
  spec.email         = ["theinen@tecracer.de"]
  spec.summary       = "Train Transport for Telnet connections"
  spec.description   = "Allows applications using Train connect via Telnet"
  spec.homepage      = "https://github.com/tecracer_theinen/train-telnet"
  spec.license       = "Apache-2.0"

  spec.files = %w{
    README.md train-telnet.gemspec Gemfile
  } + Dir.glob(
    "lib/**/*", File::FNM_DOTMATCH
  ).reject { |f| File.directory?(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "train", "~> 2.0"
  spec.add_dependency "net-telnet", "~> 0.2"
end
