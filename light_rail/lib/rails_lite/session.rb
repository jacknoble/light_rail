require 'json'
require 'webrick'
require 'debugger'
require_relative 'cookie'

class Session < Cookie
  COOKIE_NAME = "_light_rail_app"

  def initialize(req)
    @cookie = extract_cookie(req) || {}
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store(resp)
    store_cookie(resp, @cookie)
  end
end
