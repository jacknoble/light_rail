require 'json'
require 'webrick'
require 'debugger'

class Session
  def initialize(req)
    @cookie = extract_cookie(req) || {}
  end

  def extract_cookie(req)
    cookie = req.cookies.find do |cookie|
      cookie.name == "_light_rail_app"
    end
    cookie && JSON.parse(cookie.value)
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(resp)
    resp.cookies << WEBrick::Cookie.new("_light_rail_app", @cookie.to_json)
  end
end
