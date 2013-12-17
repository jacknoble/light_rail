require 'webrick'

server = WEBrick::HTTPServer.new(Port: 8080)
trap('INT') { server.shutdown }

server.mount_proc("/") do |req, resp|
  resp.content_type = "text/text"
  resp.body = req.path
end

server.start