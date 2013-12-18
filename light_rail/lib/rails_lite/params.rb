require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params)
    @params ||= Hash.new
    unless req.query_string.nil?
      parsed_qstring = parse_www_encoded(req.query_string)
      @params.merge!(parsed_qstring)
    end

    unless req.body.nil?
      parsed_body = parse_www_encoded(req.body)
      @params.merge!(parsed_body)
    end
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
    if decoded_form =~ /\[.\]/
      get_nested_hash(decoded_form)
    else
      query_hash = {}
      decoded_form.each do |pair|
        query_hash[pair[0]] = pair[1]
      end
      query_hash
    end
  end

  def nested_hash(decoded_form)
    body_hash = {}
    nest_array = decoded_form.map{ |pair| hash_nest(parse_key(pair)) }
    nest_array.each { |nest| body_hash = deep_merge(body_hash, nest) }
    body_hash
  end

  def parse_key(key)
    parsed_key = key.join("").split!(/\]\[|\[|\]/)
  end

  def hash_nest(pair)
    return pair[0] if pair.count == 1
    {pair[0] => hash_nest(pair[1..-1])}
  end

  def deep_merge(hash1, hash2)
    return hash1.merge!(hash2) unless hash2.values.any?{|val| val.is_a?(Hash)}
    merged_hash = {}
    overlapped_keys = hash2.keys.select{|key, value| hash1.keys.include?(key)}
    overlapped_keys.each do |key|
      merged_hash.merge!({key => deep_merge(hash1[key], hash2[key])})
    end
    [hash1, hash2].each do |hash|
      merged_hash.merge!(hash.select{|key, val| !overlapped_keys.include?(key)})
    end

    merged_hash
  end

end
