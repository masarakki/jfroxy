
require 'timecop'
require 'cache'

describe Cache::TTLCache do

  def assert_fetching_cache(key)
    called = false
    result = @cache.with_cache(key) { called = true }
    expect(called).to be true
    expect(result).to be true
  end

  before(:each) do
    @cache = Cache::TTLCache.new
  end

  context 'cache is empty' do
    it 'call block to fetch' do
      assert_fetching_cache('key')
    end
  end

  context 'cache has an entry' do
    before(:each) do
      @now = Time.now
      Timecop.freeze(@now)
      @cache.with_cache('key') { 'value' }
    end

    it 'cache returns the value without calling block' do
      result = @cache.with_cache('key') { raise 'must not called' }
      expect(result).to be == 'value'
    end

    context 'at expired time' do
      before(:each) do
        Timecop.travel(@now + 1000000) # expire the entry
      end

      it 'call block to fetch' do
        assert_fetching_cache('key')
      end
    end
  end
end

