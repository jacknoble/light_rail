class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method = pattern, http_method
    @controller_class, @action_name = controller_class, action_name
  end

  def matches?(req)
    (req.path =~ pattern) && (req.request_method.downcase.to_sym == http_method)
  end

  def run(req, resp)
    route_params = route_params(req)
    @controller_class.new(req, resp, route_params).invoke_action(action_name)
  end

  private

  def route_params(req)
    params= {}
    data = @pattern.match(req.path)
    data.names.each do |name|
      params[name.to_sym] = data[name]
    end
    params
  end

end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller, action|
      @routes << (Route.new(pattern, http_method, controller, action))
    end
  end

  def match(req)
    @routes.find do |route|
      p route.pattern
      p route.matches?(req)
      route.matches?(req)
    end
  end

  def run(req, resp)
    route = match(req)
    return resp.status = WEBrick::HTTPStatus[404] unless route
    route.run(req, resp)
  end
end
