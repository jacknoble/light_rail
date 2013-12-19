require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, resp, route_params = {})
    @req, @resp = req, resp
    @params = Params.new(req, route_params)
    @already_built_response = false
  end

  def session
    @session ||= Session.new(@req)
  end

  def redirect_to(url)
    raise "Already rendered or redirected" if already_responded?
    session.store_session(@resp)
    @resp['Location'] = url
    @resp.status = 302
    @already_built_response = true
  end

  def render_content(content, type)
    session.store_session(@resp)
    @resp.body = content
    @resp.content_type = type
    @already_built_response = true
  end

  def render(template_name)
    file_path = get_view_path(template_name)
    resp = ERB.new(File.read(file_path)).result(binding)
    render_content(resp, "text/html")
  end

  def invoke_action(name)
    send(name)
  end

  private

  def already_responded?
    @already_built_response
  end

  def get_view_path(template_name)
    classpath = self.class.to_s
      .underscore
      .gsub(/_controller/, "")
    "views/#{classpath}/#{template_name}.html.erb"
  end

end
