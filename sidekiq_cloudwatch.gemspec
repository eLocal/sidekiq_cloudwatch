
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq_cloudwatch/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq_cloudwatch"
  spec.version       = SidekiqCloudwatch::VERSION
  spec.authors       = ["Rob Di Marco"]
  spec.email         = ["rob@elocal.com"]

  spec.summary       = %q{Gem that will send Sidkiq::Stats data to AWS Cloudwatch}
  spec.description   = File.read(File.expand_path('../README.md', __FILE__))
  spec.homepage      = "https://github.com/eLocal/#{spec.name}"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq"
  spec.add_dependency "aws-sdk-cloudwatch"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
