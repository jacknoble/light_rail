class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method = pattern, http_method
    @controller_class, @action_name = controller_class, action_name
  end

  def matches?(req)
    req.path =~ @pattern &&
    req.request_method.downcase.to_sym == @http_method
  end

  def run(req, resp)
    @contoller_class.new(req, resp).invoke_action(action_name)
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
    @routes.concat(&proc.call)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller, action|
      @routes.concat(Route.new(pattern, http_method, controller, action))
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
  end

  def run(req, resp)
    route = match(req)
    (route) ? route.run : resp.status = WEBrick::HTTPStatus::reason_phrase(404)
  end
end
