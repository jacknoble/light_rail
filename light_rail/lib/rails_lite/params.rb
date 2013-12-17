require 'uri'

class Params
  def initialize(req, route_params)
    @params = URI.decode_www_form(req.query_string)
  end

  def [](key)
  end

  def to_s
  end

  private
  def parse_www_encoded(www_encoded_form)
    decode_www_form(www_encoded_form)
  end

  def parse_key(key)
  end
end
