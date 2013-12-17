require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, resp, route_params = {})
    @req, @resp = req, resp
    @params = Params.new(req, route_params)
  end

  def session(req = @req)
    @session ||= Session.new(req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    session.store_session(@resp)
    @resp.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url)
    @already_built_response = true
  end

  def render_content(content, type)
    session.store_session(@resp)
    @resp.body = content
    @resp.content_type = type
    @already_built_response = true
  end

  def render(template_name)
    @test_var = "Little Bunny Foo Foo"
    file_path = get_view_path(template_name)
    resp = ERB.new(File.read(file_path)).result(binding)
    render_content(resp, "text/html")
  end

  def invoke_action(name)
  end

  private

  def get_view_path(template_name)
    classpath = self.class.to_s
      .underscore
      .gsub(/_controller/, "")
    "views/#{classpath}/#{template_name}.html.erb"
  end

end
