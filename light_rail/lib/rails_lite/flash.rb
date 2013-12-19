require_relative 'cookie'

class Flash < Cookie
  COOKIE_NAME = "_flash"

  def initialize(req)
    @this_flash = extract_cookie(req) || {}
    @next_flash = {}
  end

  def [](key)
    @this_flash[key]
  end

  def []=(key, val)
    @next_flash[key] = val
  end

  def now
    @this_flash
  end

  def store(resp)
    store_cookie(resp, @next_flash)
  end

end
