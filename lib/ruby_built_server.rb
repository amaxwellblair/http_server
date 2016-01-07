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

  client.close
  puts "\nResponse complete"

  if output.include?("Total Requests:")
    break
  end
end
