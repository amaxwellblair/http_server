$LOAD_PATH.unshift(__dir__)
require 'server'
require 'response'
require 'socket'
require 'hurley'
require 'time'
require 'request'
require 'header'
URL = "http://127.0.0.1:9292/"

tcp_server = TCPServer.new(9292)

response = Response.new

begin
  while true
    server = Server.new(tcp_server)
    raw_request = server.receive_request
    request = Request.new(raw_request)
    response.request = request
    output = response.body
    headers = Header.new(request, response, URL)
    server.send_response(output, headers)
    break if shutdown(output)
  end

rescue => error
  request_lines[0] = request_lines[0].sub("/force_error", "/error_back_trace")
  request = Request.new(request_lines)
  response.request = request
  response.error_back_trace(error.backtrace.join("\n"))
  puts response.request.path
  output = response.body

  headers = Header.new(request, response, URL)
  client.puts headers.create
  client.puts output

  puts ["Wrote this response:", headers.create, output].join("\n")

  puts "\nResponse complete"

  client.close
end
