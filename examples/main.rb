require 'memodis'
require 'benchmark'
def fib(num)
  return num if num < 2
  fib(num - 1) + fib(num - 2)
end

puts "Before memoize: "

non_memoized = Benchmark.measure do
puts fib(33) => 3524578 # after ~ 7 seconds
end
puts non_memoized




extend Memodis
memoize :fib, Memodis::DistCache.new({
  :key_gen => lambda { |k| "fib(#{k})" },
    :decoder => :integer,
    :expires => (10 * 60),
    :master  => '127.0.0.1:6379',
    :slaves  => ['127.0.0.1:6379']
})
memoized = []

memoized << Benchmark.measure do
puts fib(33) => 3524578 # after ~ 0.03   seconds
end
memoized <<  Benchmark.measure do 
puts fib(33) => 3524578 # after ~ 0.0001 seconds
end

memoized << Benchmark.measure do 
puts fib(33) => 3524578 # after ~ 0.0001 seconds
end
puts "After memoize: "
puts memoized.join("\n")
