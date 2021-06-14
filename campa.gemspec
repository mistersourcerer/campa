# frozen_string_literal: true

require_relative "lib/campa/version"

Gem::Specification.new do |spec|
  spec.name          = "campa"
  spec.version       = Campa::VERSION
  spec.authors       = ["Ricardo Valeriano"]
  spec.email         = ["ricardo.valeriano@gmail.com"]

  spec.summary       = "A tiny lispey type of thing for learning purposes."
  spec.description   = "A tiny lispey type of thing for learning purposes."
  spec.homepage      = "https://github.com/mistersourcerer/campa"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mistersourcerer/campa."
  spec.metadata["changelog_uri"] = "https://github.com/mistersourcerer/campa/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
