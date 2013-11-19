require File.expand_path('lib/memodis/version.rb')
Gem::Specification.new do |s|
  s.name        = 'memodis'
  s.version     = Memodis::VERSION
  s.date        = '2010-02-14'
  s.summary     = "Redis backed memoization helpers"
  s.description = "Redis backed memoization helpers"
  s.authors     = ["Levi Cook"]
  s.files       = ["lib/memodis.rb"]
  s.homepage    = 'https://github.com/levicook/memodis.git'
end
