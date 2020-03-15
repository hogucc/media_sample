# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$:.unshift(lib) unless $:.include?(lib)
require 'mini_mime/version'

Gem::Specification.new do |spec|
  spec.name          = 'mini_mime'
  spec.version       = MiniMime::VERSION
  spec.authors       = ['Sam Saffron']
  spec.email         = ['sam.saffron@gmail.com']

  spec.summary       = 'A lightweight mime type lookup toy'
  spec.description   = 'A lightweight mime type lookup toy'
  spec.homepage      = 'https://github.com/discourse/mini_mime'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.13'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
