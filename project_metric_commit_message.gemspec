# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "project_metric_commit_message/version"

Gem::Specification.new do |spec|
  spec.name          = "project_metric_commit_message"
  spec.version       = ProjectMetricCommitMessage::VERSION
  spec.authors       = ["an-ju"]
  spec.email         = ["an_ju@berkeley.edu"]

  spec.summary       = %q{A metric that checkes commit messages and sumarize commit types}
  spec.description   = %q{This is a metric gem to check commit messages.}
  spec.homepage      = "https://github.com/an-ju/projectscope"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'octokit', '~> 4.0'
end
