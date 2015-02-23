# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pundit_custom_errors/version'

Gem::Specification.new do |spec|
  spec.name          = 'pundit_custom_errors'
  spec.version       = PunditCustomErrors::VERSION
  spec.authors       = ['Luis Daher', 'Damien Wilson']
  spec.email         = ['luisotaviodaher@gmail.com', 'damien@mindglob.com']
  spec.summary       = 'Custom error messages for Pundit.'
  spec.description   = %(Contains a monkey patch that enables
                         custom error messages for Pundit.)
  spec.homepage      = 'http://luisdaher.net'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{/^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{/^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.1'
  spec.add_development_dependency 'factory_girl', '~> 4.0'
  spec.add_development_dependency 'rubocop', '~> 0.28', '>= 0.28.0'
  spec.add_dependency 'pundit', '~> 0.3', '>= 0.3.0'
end
