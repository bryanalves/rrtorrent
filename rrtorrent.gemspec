lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'rrtorrent'
  spec.summary = 'Client library for rtorrent'
  spec.description = 'SCGI bindings for rtorrent in ruby'
  spec.homepage = 'https://www.github.com/bryanalves/rrtorrent'
  spec.version = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  spec.authors = ['Bryan Alves']
  spec.email = 'bryanalves@gmail.com'

  spec.license = 'MIT'

  spec.files = Dir['lib/**/*', 'Rakefile', 'README.md']
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']
end
