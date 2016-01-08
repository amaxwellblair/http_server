$LOAD_PATH.unshift(__dir__)
require 'server'
require 'response'
require 'socket'
require 'hurley'
require 'time'
require 'request'
require 'header'
URL = "http://127.0.0.1:#{ARGV[0]}/"

tcp_server = TCPServer.new(ARGV[0].to_i)

response = Response.new

#Request (Take Input) -> Do Something -> Response (Send Output)

begin
  while true
    server = Server.new(tcp_server)
    raw_request = server.receive_request
    request = Request.new(raw_request)

    response.request = request
    output = response.body
    headers = Header.new(request, response, URL)
    # path = PathHandler.new(request)
    # server.send(path.response)
    server.send_response(output, headers)
    break if server.shut_down?(output)
  end

rescue => error
  raw_request[0] = raw_request[0].sub("/force_error", "/error_back_trace")
  request = Request.new(raw_request)
  response.request = request
  response.error_back_trace(error.backtrace.join("\n"))
  output = response.body
  headers = Header.new(request, response, URL)
  server.send_response(output, headers)
end
