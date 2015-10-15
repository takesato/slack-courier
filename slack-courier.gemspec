# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack/courier/version'

Gem::Specification.new do |spec|
  spec.name          = "slack-courier"
  spec.version       = Slack::Courier::VERSION
  spec.authors       = ["takehito sato"]
  spec.email         = ["takehitosato@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/takesato/slack-courier"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "httmultiparty"
  spec.add_runtime_dependency "dotenv"
  spec.add_runtime_dependency "multi_json", ">= 1.0.3", "~> 1.0"
  spec.add_runtime_dependency "faye-websocket", "~> 0.9.2"end
