require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params = {})
    @params = route_params
    @params.merge!(parse_query_string(req))
    @params.merge!(parse_request_body(req))
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded(www_encoded_form)
    decoded_form = URI.decode_www_form(www_encoded_form)
    nested = {}
    decoded_form.map do |pair|
      els= ((pair[0] =~ /\[.*\]/) ? parse_pair(pair) : pair)
      nested = deep_merge(nested, hash_nest(els))
    end
    nested
  end

  def parse_query_string(req)
    return {} unless req.query_string
    parse_www_encoded(req.query_string)
  end

  def parse_request_body(req)
    return {} unless req.body
    parse_www_encoded(req.body)
  end

  def parse_pair(pair)
    parsed_kv_pair = pair.join("").split(/\]\[|\[|\]/)
  end

  def hash_nest(pair)
    return pair[0] if pair.count == 1
    {pair[0] => hash_nest(pair[1..-1])}
  end

  def deep_merge(hash1, hash2)
    return hash1.merge!(hash2) unless hash2.values.any?{|val| val.is_a?(Hash)}

    merged_hash = {}
    overlapped_keys = hash1.keys & hash2.keys
    overlapped_keys.each do |key|
      merged_hash[key] = deep_merge(hash1[key], hash2[key])
    end

    [hash1, hash2].each do |hash|
      merged_hash.merge!(hash.select{|key, val| !overlapped_keys.include?(key)})
    end

    merged_hash
  end

end
