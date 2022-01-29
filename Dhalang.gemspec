
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "Dhalang/version"

Gem::Specification.new do |spec|
  spec.name          = "Dhalang"
  spec.version       = Dhalang::VERSION
  spec.authors       = ["Niels Steensma"]
  spec.email         = ["nielssteensma@yahoo.nl"]
  spec.licenses      = ['MIT']

  spec.summary       = "Ruby wrapper for Puppeteer. Generate screenshots and PDF's from HTML!"
  spec.homepage      = "https://github.com/NielsSteensma/Dhalang"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3.6"
  spec.add_development_dependency "fastimage", "~> 2.2.6"
  spec.add_development_dependency "pdf-reader", "~> 2.9.0"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.0"
end
