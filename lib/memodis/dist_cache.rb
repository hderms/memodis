require 'redis'
module Memodis
  class DistCache

    CODERS = {}
    CODERS.default   = lambda { |v| v }
    CODERS[:float]   = lambda { |v| Float(v) }
    CODERS[:integer] = lambda { |v| Integer(v) }
    CODERS.freeze

    def initialize(options)
      @master = Redis.new({
        :db => options[:db],
        :host => options[:host],
        :port  => options[:port],
        :timeout => options[:timeout]
      })
      @encoder = resolve_coder(options[:encoder])
      @decoder = resolve_coder(options[:decoder])
      @key_gen = options.fetch(:key_gen, lambda { |k| k })
      @expires = options[:expires]
    end

    def []= key, val
      key = canonicalize(key)
      @master.set(key, encode(val))
      @master.expire(key, @expires) unless @expires.nil?
    end

    def [] key
      key = canonicalize(key)
      if val = get(key)
        decode(val)
      else
        nil # don't decode a miss
      end
    end

    private

    def canonicalize(key)
      @key_gen.call(key)
    end


    def get key
      # TODO log warning if s_node == m_node
      @master.get(key)
    end

    def decode(val)
      @decoder.call(val)
    end

    def encode(val)
      @encoder.call(val)
    end

    def resolve_coder(coder_spec)
      case coder_spec 
      when Proc
        coder_spec
      else
        CODERS[coder_spec]
      end
    end

  end
end
