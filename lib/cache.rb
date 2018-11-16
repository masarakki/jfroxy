
module Cache
  # This class represents a very simple cache with TTL (time to live).
  # Cached data (key and value) must has #hash and #eq?.
  class TTLCache
    Entry = Struct.new('Entry', :value, :ttl)

    def initialize(timeout_sec: 300)
      @entries = {}
      @timeout_sec = timeout_sec
    end

    def with_cache(key)
      now = Time.now
      expire_old_entry(now)
      if @entries.has_key?(key) && now <= @entries[key].ttl
        return @entries[key].value
      end
      value = yield
      @entries[key] = Entry.new(value, now + @timeout_sec)
      value
    end

    def clear
      @entries = {}
      nil
    end

    private

    # From the oldest entry, find expired entries and delete it
    def expire_old_entry(now)
      @entries.each_value.take_while {|e| e.ttl < now }.each {|e| @entries.delete(e) }
      nil
    end
  end
end

