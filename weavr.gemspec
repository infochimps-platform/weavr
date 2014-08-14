lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weavr/version'

Gem::Specification.new do |gem|
  gem.name          = 'weavr'
  gem.version       = Weavr::VERSION
  gem.authors       = ['Travis Dempsey']
  gem.email         = ['dempsey.travis@gmail.com']
  gem.licenses      = ['Apache 2.0']
  gem.homepage      = 'https://github.com/infochimps-labs/weavr.git'
  gem.summary       = 'A Ruby library for Apache Ambari REST client'
  gem.description   = <<-DESC.gsub(/^ {4}/, '').chomp
    Weavr
  DESC

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(/^bin/){ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)/)
  gem.require_paths = ['lib']

  gem.add_development_dependency('bundler', '~> 1.6.2')

  gem.add_dependency('activesupport',       '~> 4.1.4')
  gem.add_dependency('faraday',             '~> 0.9.0')
  gem.add_dependency('faraday_middleware',  '~> 0.9.1')
  gem.add_dependency('gorillib-model',      '~> 0.0.1')
  gem.add_dependency('multi_json',          '~> 1.10.1')
end
