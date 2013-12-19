require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class TestsController < ControllerBase
  def go
    # redirect_to( "http://www.googl.com")


    # after you have template rendering, uncomment:
   # render :show

    # after you have sessions going, uncomment:
    # p session
   flash.now[:errors] = "There was an error!"
   render :errors
  end
end

server.mount_proc '/' do |req, res|
  TestsController.new(req, res).go
end

server.start
