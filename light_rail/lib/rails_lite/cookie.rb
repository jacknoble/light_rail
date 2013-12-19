class Cookie

  def extract_cookie(request)
    cookie = request.cookies.find do |cookie|
      cookie.name == self.class::COOKIE_NAME
    end
    cookie && JSON.parse(cookie.value)
  end

  def store_cookie(response, cookie)
    response.cookies << WEBrick::Cookie.new(self.class::COOKIE_NAME, cookie.to_json)
  end


end