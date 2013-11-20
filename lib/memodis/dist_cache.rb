require 'redis'
MEMODIS_KEYS_SET = "MEMODIS_KEYS"
MEMODIS_KEYS_SET_EXPIRATION = 604800
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
      set_keys_set_expiration unless keys_set_exists?
    end

    def []= key, val
      key = canonicalize(key)
      @master.set(key, encode(val))
      @master.sadd(MEMODIS_KEYS_SET, key)
      @master.expire(key, @expires) unless @expires.nil?
    end
    
    def del(key)
      key = canonicalize(key)
      @master.srem(MEMODIS_KEYS_SET, key)
      @master.del(key)
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


    def set_keys_set_expiration
      @master.expire MEMODIS_KEYS_SET, MEMODIS_KEYS_SET_EXPIRATION
    end
    def keys_set_exists?
      @master.exists MEMODIS_KEYS_SET
    end
    def in_keys_set?(key)
      @master.sismember(MEMODIS_KEYS_SET, key)
      end

    def get key
      # TODO log warning if s_node == m_node
      return nil unless in_keys_set?(key)

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
