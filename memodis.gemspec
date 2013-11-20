require File.expand_path('lib/memodis/version.rb')
Gem::Specification.new do |s|
  s.name        = 'memodis'
  s.version     = Memodis::VERSION
  s.date        = '2010-02-14'
  s.summary     = "Redis backed memoization helpers"
  s.description = "semi-transparent memoization; backed by redis;"
  s.authors     = ["Levi Cook"]
  s.email     =  "levicook@gmail.com"
  s.files       = ["lib/memodis.rb", "lib/memodis/dist_cache.rb", "lib/memodis/version.rb", "vendor/memoizable.rb"]
  s.homepage    = 'https://github.com/levicook/memodis'
  s.add_runtime_dependency 'redis', '>= 3.0.0'
  s.add_runtime_dependency 'daemon_controller', '>= 1.1.7'
  s.add_runtime_dependency 'memoizable', '>= 0.2.0'
  s.add_development_dependency 'riot', '>= 0'
  s.add_development_dependency 'reek', '>= 0'
  s.add_development_dependency 'daemon_controller', '>= 0'
end
