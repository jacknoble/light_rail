require 'uri'

class Params
  def initialize(req, route_params)
    @params ||= Hash.new
    unless req.query_string.nil?
      @params.merge(URI.decode_www_form(req.query_string))
    end

    unless req.body.nil?
      parsed_body = parse_www_encoded(req.body)
      @params.merge(parsed_body)
    end
  end

  def [](key)
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded(www_encoded_form)
    decoded_body = URI.decode_www_form(www_encoded_form)
    body_hash = Hash.new
    decoded_body.split(", ").each do |pair|
      hash = create_body_hash(parse_key(pair.flatten!))
      p hash
      body_hash.merge(hash)
    end
  end

  def create_body_hash(pair)
    return pair if pair.count == 1
    {pair[0] => create_body_hash(pair[1..-1])}
  end


  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

end
