require 'json'
require 'webrick'
require 'debugger'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == "_light_rail_app"
        @cookie = JSON.parse(cookie.value)
      else
        next
      end
    end
    @cookie ||= {}
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
