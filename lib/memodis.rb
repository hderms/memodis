require 'rubygems'

require 'pathname'


module Memodis

  # slurp cool vendor goodies into our namespace. would declare them 
  # as gem dependencies, but they don't seem to be published...

  vendor_path = Pathname.new(__FILE__).parent.parent + 'vendor'
  class_eval((vendor_path+'memoizable.rb').read) unless defined? Memodis::Memoizable
  class_eval((vendor_path+'weak_cache.rb').read) unless defined? Memodis::WeakCache

  include Memodis::Memoizable

end
