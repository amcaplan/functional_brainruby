require_relative 'lib/functional_brainruby/version'

Gem::Specification.new do |spec|
  spec.name          = "functional_brainruby"
  spec.version       = FunctionalBrainruby::VERSION
  spec.authors       = ["Ariel Caplan"]
  spec.email         = ["arielmcaplan@gmail.com"]

  spec.summary       = %q{Ruby... Optimized for Programmer Sadness!}
  spec.description   = %q{Now with more functions!}
  spec.homepage      = "https://github.com/amcaplan/functional_brainruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/amcaplan/functional_brainruby"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
