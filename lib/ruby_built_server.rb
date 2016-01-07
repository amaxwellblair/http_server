$LOAD_PATH.unshift(__dir__)
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
    client = tcp_server.accept
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    puts "Got this request:"
    puts request_lines.inspect
    puts "Sending response."

    request = Request.new(request_lines)
    response.request = request
    output = response.body
    headers = Header.new(request, response, URL)
    client.puts headers.create
    client.puts output

    puts ["Wrote this response:", headers.create, output].join("\n")

    puts "\nResponse complete"

    client.close

    if output.include?("Total Requests:")
      break
    end
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
